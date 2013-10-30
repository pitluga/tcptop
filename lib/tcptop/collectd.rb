module Tcptop
  class Collectd
    def self.reading(active, queued, hostname, label, io=STDOUT)
      time = Time.now.to_i
      io.write "PUTVAL #{hostname}/#{label}/gauge-active #{time}:#{active}\n"
      io.write "PUTVAL #{hostname}/#{label}/gauge-queued #{time}:#{queued}\n"
      io.flush
    end
  end
end
