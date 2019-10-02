Test task

Install:

1. Copy /usr to /usr, /etc to /etc
2. Leave /t at homedir or place it everywhere
3. Change host and port in /usr/local/share/tarantool/test.lua/config.lua corresponding to your host settings

$ cd ~

$ prove

Dependencies:

* tarantool:
    tarantool-http

* perl:
    LWP::UserAgent
    Test::More
    JSON