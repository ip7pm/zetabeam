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
    # Infinite loop makes the Beam::Process running for ever
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

# Start a Beam::Process running the Worker.run() method in
# a separate thread and get the Beam::Process id (i.e pid)
pid = Beam::spawn Worker, :run, []

# Send messages to the Beam::Process using his pid
Beam::msg pid, [:msg, 'hello world']
sleep 1
Beam::msg pid, [:msg, 'another message']
sleep 1
Beam::msg pid, [:unknown, 'bad message']
sleep 1
Beam::msg pid, [:msg, 72]    # Will not pattern match, data must be a String
sleep 1

# And the Beam::Process is still alive
puts "Process pid: #{pid} is alive?: #{Beam::Process::alive? pid}"

# Wait a little bit otherwise the main process (i.e the current program)
# is dying before the Beam::Process thread can do anything
sleep 2
puts '--- bye ---'
