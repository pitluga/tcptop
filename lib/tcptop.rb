require "tcptop/version"
require "tcptop/collectd"
require 'rubygems'
require 'raindrops'
require 'optparse'

LAYOUT = "%-20s %-8s %-8s"

module Tcptop
  def self.parse_options!
    options = {:tcp => [], :unix => [], :interval => 2, :sort => :active}
    OptionParser.new do |opts|
      opts.banner = "Usage: tcptop [options]"

      opts.on("-t", "--tcp SOCKET", "tcp socket to filter, can be used multiple times") do |sock|
        options[:tcp] << sock
      end
      opts.on("-u", "--unix PATH", "domain socket to filter, can be used multiple times, will not show by default") do |path|
        options[:unix] << path
      end
      opts.on("-1", "--once", "print once and exit") do
        options[:once] = true
      end
      opts.on("-n", "--interval SECONDS", Float, "seconds between stat collection, DEFAULT: 2") do |interval|
        options[:interval] = interval
      end
      opts.on("--queued", "sort on queued requests, defaults to active") do
        options[:sort] = :queued
      end
      opts.on("--collectd LABEL", "print output suitable for collectd, must also provide socket or path") do |label|
        options[:collectd] = label
      end
      opts.on("-v", "--version", "prints the version and exits") do
        options[:version] = true
      end
    end.parse!
    options
  end

  def self.run!
    options = parse_options!
    if options[:version]
      puts "tcptop: version #{Tcptop::VERSION}"
      exit 0
    elsif options[:once]
      print_info(options[:tcp], options[:unix], options[:sort])
      exit 0
    elsif options[:collectd]
      unless options[:tcp].size == 1 || options[:unix].size == 1
        puts "the --tcp or --unix option must be used once to identify the socket"
        exit 1
      end

      Signal.trap("INT") { exit 0 }
      hostname = ENV["COLLECTD_HOSTNAME"] || 'localhost'
      interval = (ENV["COLLECTD_INTERVAL"] || '60').to_i
      label = options[:collectd]

      loop do
        stats = nil
        if options[:tcp].size > 0
          _, stats = Raindrops::Linux.tcp_listener_stats(options[:tcp]).first
        else
          _, stats = Raindrops::Linux.unix_listener_stats(options[:unix]).first
        end
        Collectd.reading(stats.active, stats.queued, hostname, label)
        sleep interval
      end
    else
      Signal.trap("INT") { exit 0 }

      loop do
        system "clear"
        puts "Updated: #{Time.now}, checking every #{options[:interval]} seconds"
        puts
        print_info(options[:tcp], options[:unix], options[:sort])
        sleep options[:interval]
      end
    end
  end

  def self.print_info(sockets, paths, sort)
    puts LAYOUT % [
      "Socket",
      "Active" + (sort == :active ? "*" : ""),
      "Queued" + (sort == :queued ? "*" : "")
    ]
    responses = if sockets.empty?
                  Raindrops::Linux.tcp_listener_stats
                else
                  Raindrops::Linux.tcp_listener_stats(sockets)
                end
    if paths.any?
      responses.merge!(Raindrops::Linux.unix_listener_stats(paths))
    end

    responses.sort_by { |(a, s)| -1 * s.send(sort) }.each do |(address, stats)|
      puts LAYOUT % [address, stats.active, stats.queued]
    end
  end

end
