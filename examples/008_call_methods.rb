require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{me()}"
    loop {
      case receive
      in [method, args] if method.is_a? Symbol and args.is_a? Array
        if respond_to? method
          send method, *args
        else
          puts "Worker, pid #{me()}: Unknown method: #{method}"
        end
      else
        puts "Worker pid: #{me()}, recv: Unknown message"
      end
    }
  end

  def job_compute(n)
    puts "Worker compute n=#{n}"
  end

  def job_name(title, name)
    puts "Worker, Welcome #{title} #{name}"
  end
end

# Start the Actor
pid = Beam::spawn Worker, :run, []
sleep 0.2

# Output the running Actors list
puts '-'*10
p Beam::Actor::list()
puts '-'*10

# Send message to Worker
# But here the message format is like so:
# - First item of the array is the method of the Actor we want to call
# - Second item of the array are the arguments of the method we want to call
# It mean the Worker.run() method act like a method dispacher
Beam::msg pid, [:job_compute, [4]]
Beam::msg pid, [:job_name, ['Mr', 'Bob']]
puts ''
Beam::msg pid, [:no_method, []]
Beam::msg pid, ['bad', 'message']

sleep 2
puts '--- bye ---'
