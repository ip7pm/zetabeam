require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{me()}"
    loop {
      case receive
      in [:ping, pid]
        puts "Worker pid: #{me()}, recv: ping from pid: #{pid}"
        msg pid, [:pong, me()]
      else
        puts "Worker pid: #{me()}, recv: Unknown message"
      end
    }
  end
end

pid = Beam::spawn Worker, :run, []
Beam::msg pid, [:ping, Beam::me()]

# Main ruby process act like an Beam::Process with pid: #PID<0.0.0> and
# be able to send and receive message to other Beam::Process
case Beam::receive
in [msg, from] then
  puts "Main Process recv: #{msg} from #{from}"
else
  puts "Main Process, recv: Unknown message"
end

puts '--- bye ---'
