require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{@pid}"

    loop {
      msg, data = receive
      if msg == :msg
        puts "Worker recv: #{data}"
      else
        puts "Worker recv: Unknown message"
      end
    }
  end
end


pid = Beam::spawn Worker, :run, []

Beam::msg pid, [:msg, 'hello world']
sleep 1

Beam::msg pid, [:msg, 'another message']
sleep 1

Beam::msg pid, [:unknown, 'another message']
sleep 1

sleep 2
