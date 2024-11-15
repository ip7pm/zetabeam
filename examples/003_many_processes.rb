require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{@pid}"

    loop {
      msg, data = receive
      if msg == :msg
        puts "Worker pid: #{@pid} recv: #{data}"
      else
        puts "Worker pid: #{@pid} recv: Unknown message"
      end
    }
  end
end


class Watcher < Beam::Spawnable
  def run()
    puts "Watcher started, pid: #{@pid}"

    loop {
      msg, data = receive
      if msg == :msg
        puts "Watcher, pid: #{@pid} recv: #{data}"
      else
        puts "Watcher, pid: #{@pid} recv: Unknown message"
      end
    }
  end
end


pid_worker = Beam::spawn Worker, :run, []
pid_watcher = Beam::spawn Watcher, :run, []

puts '-'*10
p Beam::Process::list()
puts '-'*10

Beam::msg pid_worker, [:msg, 'hello world to worker']
Beam::msg pid_watcher, [:msg, 'hello world to watcher']

sleep 2
