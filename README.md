# Tcptop

A TCP connection monitor that builds upon [raindrops](http://raindrops.bogomips.org/). Useful for monitoring a pool of unicorn workers.

## Installation

Install it using:

    $ gem install tcptop

## Usage

    $ tcptop -h
    Usage: tcptop [options]
    -t, --tcp SOCKET                 tcp socket to filter, can be used multiple times
    -u, --unix PATH                  domain socket to filter, can be used multiple times, will not show by default
    -1, --once                       print once and exit
    -n, --interval SECONDS           seconds between stat collection, DEFAULT: 2
        --queued                     sort on queued requests, defaults to active
        --collectd LABEL             print output suitable for collectd, must also provide socket or path
    -v, --version                    prints the version and exits

Output:

    $ tcptop -1
    Socket               Active*  Queued 
    0.0.0.0:22           3        0      
    0.0.0.0:8080         1        1      
    [::%2510935584]:22   0        0      
    [::%2510935584]:80   0        0      
    [::1%2510935584]:25  0        0      
    127.0.0.1:25         0        0      
    127.0.0.1:11211      0        0      

## Domain Sockets

Unix sockets do not show up by default, if you wish to monitor a unix socket, you must pass the --unix flag

    $ tcptop -1 --unix /tmp/foo.sock
    Socket               Active*  Queued
    /tmp/foo.sock        0        0     

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
