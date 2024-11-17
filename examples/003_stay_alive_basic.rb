require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{me()}"
    # Infinite loop makes the process running for ever
    # (so, it can handle many messages)
    loop {
      msg, data = receive
      if msg == :msg
        puts "Worker pid: #{me()}, recv: #{data}"
      else
        puts "Worker pid: #{me()}, recv: Unknown message"
      end
    }
  end
end

# Start a 'process' running the Worker.run() method in
# a separate thread and get the 'process' id (i.e pid)
pid = Beam::spawn Worker, :run, []

# Send messages to the 'process' using his pid
Beam::msg pid, [:msg, 'hello world']
sleep 1
Beam::msg pid, [:msg, 'another message']
sleep 1
Beam::msg pid, [:unknown, 'bad message']
sleep 1

# And the 'process' is still alive
puts "Process pid: #{pid} is alive?: #{Beam::Process::alive? pid}"

# Wait a little bit otherwise the main process (i.e the current program)
# is dying before the thread can do anything
sleep 2
puts '--- bye ---'
