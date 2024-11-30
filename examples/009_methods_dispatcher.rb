require_relative '../lib/beam'

# -------------------------------------------------------------------
# NOTE:
# Keep in mind that Beam::Process are nothing related with operating
# system process or Ruby Process class. It's basically the trick used
# to mimic Erlang VM Process system by using Thread.
# -------------------------------------------------------------------

# NOTE:
# This the same example as 007_call_methods.rb but using the
# the helper module : Beam::Helper::MethodsDispatcher

class Worker < Beam::Spawnable
  include Beam::Helper::MethodsDispatcher

  def job_compute(n)
    puts "Worker compute n=#{n}"
  end

  def job_name(title, name)
    puts "Worker, Welcome #{title} #{name}"
  end
end

# Start the Beam::Process
pid = Beam::spawn Worker, :run, []
sleep 0.2

# Output the running Beam::Process list
puts '-'*10
p Beam::Process::list()
puts '-'*10

# Send messages
Beam::msg pid, [:job_compute, [4]]
Beam::msg pid, [:job_name, ['Mr', 'Bob']]
puts ''
Beam::msg pid, [:no_method, []]
Beam::msg pid, ['bad', 'message']

sleep 2
puts '--- bye ---'
