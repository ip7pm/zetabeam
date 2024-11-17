require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{@pid}"
    loop {
      method, args = receive
      if respond_to? method
        send method, *args
      else
        puts "Worker, pid #{@pid}: Unknown method: #{method}"
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

# Start the process
pid = Beam::spawn Worker, :run, []
sleep 0.2

# Output the running processes list
puts '-'*10
p Beam::Process::list()
puts '-'*10

# Send message to Worker
# But here the message format is like so:
# - First item of the array is the method of the processwe want to call
# - Second item of the array are the arguments of the method we want to call
# It mean the Worker.run() method act like a method dispacher
Beam::msg pid, [:job_compute, [4]]
Beam::msg pid, [:job_name, ['Mr', 'Bob']]
Beam::msg pid, [:no_method, []]

sleep 2
puts '--- bye ---'
