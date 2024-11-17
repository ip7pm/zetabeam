require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{@pid}"   # Can use the me() method instead

    # The receive() method is blocking until a message
    # is available in the 'process' mailbox
    msg, data = receive
    if msg == :msg
      puts "Worker pid: #{me()}, recv: #{data}"
    else
      puts "Worker pid: #{me()}, recv: Unknown message"
    end
  end
end

# Start a 'process' running the Worker.run() method in
# a separate thread and get the 'process' id (i.e pid)
pid = Beam::spawn Worker, :run, []
sleep 0.2

puts "Process pid: #{pid} is alive?: #{Beam::Process::alive? pid}"

# Send a message to the 'process' using his pid
Beam::msg pid, [:msg, 'hello world']
sleep 0.2

puts "Process pid: #{pid} is alive?: #{Beam::Process::alive? pid}"

# 1/ The 'process' wait until it receive a message
# 2/ The 'process' handle the message
# 3/ Then the 'process' die and does not exists anymore

# Wait a little bit otherwise the main process (i.e the program)
# is dying before the thread can do something
sleep 2
puts '--- bye ---'
