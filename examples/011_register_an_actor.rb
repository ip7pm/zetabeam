require_relative '../lib/beam'

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

# Start a Worker Actor
pid = Beam::spawn Worker, :run, []

# Register the Actor with the name ':worker'
Beam::Actor::register pid, :worker

# List of registered names
p Beam::Actor::registered()

# Send a message to the Actor using his pid
Beam::msg pid, [:msg, 'hello world using pid']

# Send a message to the Actor using his registered name
Beam::msg :worker, [:msg, 'hello world using name']

sleep 2
puts '--- bye ---'
