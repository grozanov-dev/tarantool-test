use 5.026;

use strict;
use warnings;

use Test::More 'tests' => 21;
use LWP::UserAgent qw//;
use JSON;

use FindBin qw/$RealBin/;
use lib $RealBin.'/../lib';
use Data::Dumper;

my $host = '192.168.112.132';
my $port = 8080;
my $key  = 'key_' . ( int rand 1e10 );

{
    my $ua = LWP::UserAgent->new(timeout => 10);

    my $res = $ua->post("http://$host:$port/kv", Content => JSON::to_json({ key => $key, value => '{"id":"qps_1234"}' }));

    ok ($res->{_rc} == 200, 'Status is OK');

    sleep 1;

    for my $i (1..20) {
	my $res = $ua->get("http://$host:$port/kv/" . $key);
	ok ($res->{_rc} == $i > 10 ? 429 : 200, 'Status is OK');
    }
}

1;