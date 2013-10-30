module Tcptop
  class Collectd
    def self.reading(active, queued, hostname, label, io=STDOUT)
      time = Time.now.to_i
      io.write "PUTVAL #{hostname}/#{label}/absolute-active #{time}:#{active}\n"
      io.write "PUTVAL #{hostname}/#{label}/absolute-queued #{time}:#{queued}\n"
      io.flush
    end
  end
end
