require_relative '../lib/beam'

class Watcher < Beam::Spawnable
  def run()
    puts "Watcher started, pid: #{me()}"
    loop {
      msg, pid_worker, data = receive
      if msg == :msg
        puts "Watcher, pid: #{me()} recv: #{data}"
        # Send message to worker using the pid we receive
        msg pid_worker, [:msg, data + " - from watcher #{me()}"]
      else
        puts "Watcher, pid: #{me()} recv: Unknown message"
      end
    }
  end
end

class Worker < Beam::Spawnable
  def run(idx)
    puts "Worker (#{idx}) started, pid: #{me()}"
    loop {
      msg, data = receive
      if msg == :msg
        puts "Worker (#{idx}) pid: #{me()} recv: #{data}"
      else
        puts "Worker (#{idx}) pid: #{me()} recv: Unknown message"
      end
    }
  end
end

# Start processes
pid_worker1 = Beam::spawn Worker, :run, [1]
pid_worker2 = Beam::spawn Worker, :run, [2]
pid_watcher = Beam::spawn Watcher, :run, []
sleep 0.2

# Output the running processes list
puts '-'*10
p Beam::Process::list()
puts '-'*10

# Send message to Watcher, and Watcher will forword the
# message to Wokers
Beam::msg pid_watcher, [:msg, pid_worker1, 'hello world']
Beam::msg pid_watcher, [:msg, pid_worker2, 'hello world']

sleep 2
puts '--- bye ---'
