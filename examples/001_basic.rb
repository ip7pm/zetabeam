require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{@pid}"   # Can use the me() method instead

    # The receive() method is blocking until a message
    # is available in the Actor mailbox
    msg, data = receive
    if msg == :msg
      puts "Worker pid: #{me()}, recv: #{data}"
    else
      puts "Worker pid: #{me()}, recv: Unknown message"
    end
  end
end

# Start a Actor running the Worker.run() method in
# a separate thread and get the Actor id (i.e pid)
pid = Beam::spawn Worker, :run, []

# Send a message to the Actor using his pid
Beam::msg pid, [:msg, 'hello world']

# Wait a little bit otherwise the main Actor (i.e the current program)
# is dying before the thread can do anything
sleep 2
puts '--- bye ---'
