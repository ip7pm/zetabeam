require_relative '../lib/beam'

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

class Watcher < Beam::Spawnable
  def run()
    puts "Watcher started, pid: #{me()}"

    # Start 10 Worker Actors
    pids = []
    10.times do |idx|
      pids << spawn(Worker, :run, [idx])
    end

    loop {
      case receive
      in [:msg, data] if data.is_a? String
        puts "Watcher, pid: #{me()} recv: #{data}"
        worker_pid = pids[rand(0..9)]
        msg worker_pid, [:msg, data + " - from watcher #{me()}"]
      else
        puts "Watcher, pid: #{me()} recv: Unknown message"
      end
    }
  end
end

# Start Watcher Actor
pid = Beam::spawn Watcher, :run, []
sleep 0.2

# Output the running Actors list
puts '-'*10
p Beam::Actor::list()
puts '-'*10

# Inifite loop sending message to watcher
counter = 1
loop {
  Beam::msg pid, [:msg, "Launch rocket: #{counter}"]
  counter += 1
  sleep 1
}

# Ctrl+c to Stop
puts '--- bye ---'
