require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{me()}"
    loop {
      case receive
      in [pid, :add, a, b] then
        msg = "#{a} + #{b} = #{a + b}"
        puts "Worker pid: #{me()}, recv: add -> " + msg
        msg pid, [:ack, msg]
      else
        puts "Worker pid: #{me()}, recv: Unknown message"
      end
    }
  end
end

puts '-'*20

# Start an Actor running the Worker.run()
pid = Beam::spawn Worker, :run, []

sleep 0.2
puts '-'*20

# Send a message to Worker each 1 second
_t = Thread.new {
  loop {
    sleep 1
    a, b = rand(1..500), rand(1..500)
    Beam::msg pid, [Beam::me(), :add, a, b]
    puts ''
  }
}

# Main programm act like an Actor and wait
# for receiving a Ack message
loop {
  case Beam::receive
  in [:ack, msg] then
    puts "Main Actor recv: Ack -> #{msg}"
  else
    puts "Main Actor recv: Unknown message"
  end
}

# Ctrl+c to quit
puts '--- bye ---'
