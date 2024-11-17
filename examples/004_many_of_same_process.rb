require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run(idx)
    puts "Worker (#{idx}) started, pid: #{@pid}"
    loop {
      msg, data = receive
      if msg == :msg
        puts "Worker (#{idx}), pid: #{@pid} recv: #{data}"
      else
        puts "Worker (#{idx}), pid: #{@pid} recv: Unknown message"
      end
    }
  end
end

# Start 10 'process' running the Worker.run() method
pids = []
10.times do |idx|
  pids << Beam::spawn(Worker, :run, [idx])
end
sleep 0.2

# Output the running processes list
puts '-'*10
p Beam::Process::list()
puts '-'*10

# Inifite loop sending message to a random 'process'
loop {
  pid = pids[rand(0..9)]
  Beam::msg pid, [:msg, 'hello world']
  sleep 1
}

# Ctrl+c to stop
puts '--- bye ---'
