require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run(idx)
    puts "Worker (#{idx}) started, pid: #{me()}"
    loop {
      case receive
      in [:msg, data] if data.is_a? String
        puts "Worker (#{idx}) pid: #{me()} recv: #{data}"
      else
        puts "Worker (#{idx}) pid: #{me()} recv: Unknown message"
      end
    }
  end
end

class Watcher < Beam::Spawnable
  def run()
    puts "Watcher started, pid: #{me()}"
    loop {
      case receive
      in [:msg, pid_worker, data] if data.is_a? String
        puts "Worker pid: #{me()}, recv: #{data}"
        # Send message to worker using the pid we receive
        msg pid_worker, [:msg, data + " - from watcher #{me()}"]
      else
        puts "Worker pid: #{me()}, recv: Unknown message"
      end
    }
  end
end

# Start Beam::Process
pid_worker1 = Beam::spawn Worker, :run, [1]
pid_worker2 = Beam::spawn Worker, :run, [2]
pid_watcher = Beam::spawn Watcher, :run, []
sleep 0.2

# Output the running Beam::Process list
puts '-'*10
p Beam::Process::list()
puts '-'*10

# Send message to Watcher then Watcher will forward the
# message to Wokers
Beam::msg pid_watcher, [:msg, pid_worker1, 'hello world']
Beam::msg pid_watcher, [:msg, pid_worker2, 'hello world']

sleep 2
puts '--- bye ---'
