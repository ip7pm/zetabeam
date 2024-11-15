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
    puts "Welcome #{title} #{name}"
  end
end


pid = Beam::spawn Worker, :run, []

Beam::msg pid, [:job_compute, [4]]
Beam::msg pid, [:job_name, ['Mr', 'Bob']]
Beam::msg pid, [:no_method, []]

sleep 2
