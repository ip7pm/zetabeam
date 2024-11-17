require_relative '../lib/beam'
#
# NOTE:
# When speaking about 'process' here, it is nothing related with
# Ruby Process or Operating System Process. It is basically the 'process'
# abstraction of Erlang/Elixir process system we are trying to mimic.
#

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{@pid}"   # Can use the me() method instead

    # The receive() method is blocking until a message
    # is available in the 'process' mailbox
    msg = receive
    puts "Worker pid: #{me()}, recv: #{msg}"
  end
end

# Start a 'process' running the Worker.run() method in
# a separate thread and get the 'process' id (i.e pid)
pid = Beam::spawn Worker, :run, []

# Send a message to the 'process' using his pid
Beam::msg pid, 'hello world'

# Wait a little bit otherwise the main process (i.e the current program)
# is dying before the thread can do anything
sleep 2
puts '--- bye ---'
