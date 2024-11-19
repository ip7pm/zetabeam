require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{@pid}"   # Can use the me() method instead

    # The receive() method is blocking until a message
    # is available in the Actor mailbox
    case receive
    in [:msg, data] then
      puts "Worker pid: #{me()}, recv: #{data}"
    else
      puts "Worker pid: #{me()}, recv: Unknown message"
    end
  end
end

# Start a Actor running the Worker.run() method in
# a separate thread and get the Actor id (i.e pid)
pid = Beam::spawn Worker, :run, []
sleep 0.2

puts "Actor pid: #{pid} is alive?: #{Beam::Actor::alive? pid}"

# Send a message to the Actor using his pid
Beam::msg pid, [:msg, 'hello world']
sleep 0.2

puts "Actor pid: #{pid} is alive?: #{Beam::Actor::alive? pid}"

# 1/ The Actor wait until it receive a message
# 2/ The Actor handle the message
# 3/ Then the Actor die and does not exists anymore

# Wait a little bit otherwise the main Actor (i.e the program)
# is dying before the thread can do something
sleep 2
puts '--- bye ---'
