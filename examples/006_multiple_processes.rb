require_relative '../lib/beam'

# -------------------------------------------------------------------
# NOTE:
# Keep in mind that Beam::Process are nothing related with operating
# system process or Ruby Process class. It's basically the trick used
# to mimic Erlang VM Process system by using Thread.
# -------------------------------------------------------------------

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{me()}"
    loop {
      case receive
      in [:msg, data] if data.is_a? String
        puts "Worker pid: #{me()}, recv: #{data}"
      else
        puts "Worker pid: #{me()}, recv: Unknown message"
      end
    }
  end
end

class Watcher < Beam::Spawnable
  def run()
    puts "Watcher started, pid: #{me()}"
    loop {
      case receive
      in [:msg, data] if data.is_a? String
        puts "Watcher pid: #{me()}, recv: #{data}"
      else
        puts "Watcher: #{me()}, recv: Unknown message"
      end
    }
  end
end

# Start Beam::Process
pid_worker = Beam::spawn Worker, :run, []
pid_watcher = Beam::spawn Watcher, :run, []
sleep 0.2

# Output the running Beam::Process list
puts '-'*10
p Beam::Process::list()
puts '-'*10

# Send message to each one
Beam::msg pid_worker, [:msg, 'hello world to worker']
Beam::msg pid_watcher, [:msg, 'hello world to watcher']

sleep 2
puts '--- bye ---'
