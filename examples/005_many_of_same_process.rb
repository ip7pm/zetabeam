require_relative '../lib/beam'

# -------------------------------------------------------------------
# NOTE:
# Keep in mind that Beam::Process are nothing related with operating
# system process or Ruby Process class. It's basically the trick used
# to mimic Erlang VM Process system by using Thread.
# -------------------------------------------------------------------

class Worker < Beam::Spawnable
  def run(idx)
    puts "Worker (#{idx}) started, pid: #{me()}"
    loop {
      case receive
      in [:msg, data] if data.is_a? String
        puts "Worker (#{idx}), pid: #{me()} recv: #{data}"
      else
        puts "Worker (#{idx}), pid: #{me()} recv: Unknown message"
      end
    }
  end
end

# Start 10 Beam::Process running the Worker.run() method
pids = []
10.times do |idx|
  pids << Beam::spawn(Worker, :run, [idx])
end
sleep 0.2

# Output the running Beam::Process list
puts '-'*10
p Beam::Process::list()
puts '-'*10

# Inifite loop sending message to a random Beam::Process
loop {
  pid = pids[rand(0..9)]
  Beam::msg pid, [:msg, 'hello world']
  sleep 1
}

# Ctrl+c to stop
puts '--- bye ---'
