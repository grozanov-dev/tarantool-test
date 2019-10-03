use 5.026;

use strict;
use warnings;

use Test::More 'tests' => 11;
use LWP::UserAgent qw//;
use JSON;

use FindBin qw/$RealBin/;
use lib $RealBin.'/../lib';
use Data::Dumper;

my $host = '192.168.112.132';
my $port = 8080;
my $key  = 'key_' . ( int rand 1e10 );

my @tests = (
    {
	url => '/kv',
	method => 'post',
	body => {
	    key   => $key,
	    value => '{"id":"id_1234"}'
	},
	assert => {
	    status  => 200,
	}
    },

    {
	url => '/kv',
	method => 'post',
	body => {
	    key   => $key,
	    value => '{"id":"id_1234"}'
	},
	assert => {
	    status  => 409,
	}
    },

    {
	url => '/kv/' . $key,
	method => 'get',
	assert => {
	    status  => 200,
	    content => '{"id":"id_1234"}'
	}
    },

    {
	url => '/kv/' . $key,
	method => 'put',
	body => {
	    value => '{"id":"id_4321"}'
	},
	assert => {
	    status  => 200,
	}
    },

    {
	url => '/kv/' . $key,
	method => 'get',
	assert => {
	    status  => 200,
	    content => '{"id":"id_4321"}'
	}
    },

    {
	url => '/kv/' . $key,
	method => 'delete',
	assert => {
	    status  => 200,
	}
    },

    {
	url => '/kv/' . $key,
	method => 'get',
	assert => {
	    status  => 404,
	}
    },

    {
	url => '/kv/' . $key,
	method => 'put',
	assert => {
	    status  => 404,
	}
    },

    {
	url => '/kv/' . $key,
	method => 'delete',
	assert => {
	    status  => 404,
	}
    },
);

{
    my $ua = LWP::UserAgent->new(timeout => 10);

    for my $test (@tests) {
	my $method = $test->{method};
	my $assert = $test->{assert};
	my $res = $ua->$method(
	    "http://$host:$port" . $test->{url},
	    Content => JSON::to_json($test->{body})
	);
	ok ($res->{_rc} == $assert->{status}, 'Status is OK');
        ok ($res->{_content} eq $res->{_content}, 'Content is OK') if (exists $assert->{content});
    }
}

1;