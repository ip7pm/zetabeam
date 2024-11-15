require_relative '../lib/beam'

class Watcher < Beam::Spawnable
  def run()
    puts "Watcher started, pid: #{@pid}"

    loop {
      msg, pid_worker, data = receive
      if msg == :msg
        puts "Watcher, pid: #{@pid} recv: #{data}"
        msg pid_worker, [:msg, data + ' : from watcher']
      else
        puts "Watcher, pid: #{@pid} recv: Unknown message"
      end
    }
  end
end


class Worker < Beam::Spawnable
  def run(idx)
    puts "Worker (#{idx}) started, pid: #{@pid}"

    loop {
      msg, data = receive
      if msg == :msg
        puts "Worker (#{idx}) pid: #{@pid} recv: #{data}"
      else
        puts "Worker (#{idx}) pid: #{@pid} recv: Unknown message"
      end
    }
  end
end


pid_worker1 = Beam::spawn Worker, :run, [1]
pid_worker2 = Beam::spawn Worker, :run, [2]
pid_watcher = Beam::spawn Watcher, :run, []

sleep 1

Beam::msg pid_watcher, [:msg, pid_worker1, 'hello world']
Beam::msg pid_watcher, [:msg, pid_worker2, 'hello world']

sleep 2
