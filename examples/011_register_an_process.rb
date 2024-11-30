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

# Start a Worker Beam::Process
pid = Beam::spawn Worker, :run, []

# Register the Beam::Process with the name ':worker'
Beam::Process::register pid, :worker

# List of registered names
p Beam::Process::registered()

# Send a message to the Beam::Process using his pid
Beam::msg pid, [:msg, 'hello world using pid']

# Send a message to the Beam::Process using his registered name
Beam::msg :worker, [:msg, 'hello world using name']

sleep 2
puts '--- bye ---'
