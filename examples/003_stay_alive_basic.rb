require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{me()}"
    # Infinite loop makes the actor running for ever
    # (so, it can handle many messages)
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

# Start a Actor running the Worker.run() method in
# a separate thread and get the Actor id (i.e pid)
pid = Beam::spawn Worker, :run, []

# Send messages to the Actor using his pid
Beam::msg pid, [:msg, 'hello world']
sleep 1
Beam::msg pid, [:msg, 'another message']
sleep 1
Beam::msg pid, [:unknown, 'bad message']
sleep 1
Beam::msg pid, [:msg, 72]    # Will not pattern match, data must be a String
sleep 1

# And the Actor is still alive
puts "actor pid: #{pid} is alive?: #{Beam::Actor::alive? pid}"

# Wait a little bit otherwise the main Actor (i.e the current program)
# is dying before the thread can do anything
sleep 2
puts '--- bye ---'
