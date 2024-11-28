require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{@pid}"   # Can use the me() method instead

    # The receive() method is blocking until a message
    # is available in the Beam::Process mailbox
    case receive
    in [:msg, data] then
      puts "Worker pid: #{me()}, recv: #{data}"
    else
      puts "Worker pid: #{me()}, recv: Unknown message"
    end
  end
end

# Start a Beam::Process running the Worker.run() method in
# a separate thread and get the Beam::Process id (i.e pid)
pid = Beam::spawn Worker, :run, []

# Send a message to the Beam::Process using his pid
Beam::msg pid, [:msg, 'hello world']

# Wait a little bit otherwise the main process (i.e the current program)
# is dying before the Beam::Process thread can do anything
sleep 2
puts '--- bye ---'
