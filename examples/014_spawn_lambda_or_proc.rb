require_relative '../lib/beam'

# -------------------------------------------------------------------
# NOTE:
# Keep in mind that Beam::Process are nothing related with operating
# system process or Ruby Process class. It's basically the trick used
# to mimic Erlang VM Process system by using Thread.
# -------------------------------------------------------------------

lambda_worker = -> {
  puts "Lambda Worker started, pid: #{me()}"
  loop {
    msg = receive
    puts "Lambda worker pid: #{me()}, recv: #{msg}"
  }
}

lambda_worker_args = -> (a, b) {
  puts "Lambda Worker started, pid: #{me()}, args: a=#{a}, b=#{b}"
  loop {
    msg = receive
    puts "Lambda worker pid: #{me()}, recv: #{msg}"
  }
}

# -----

proc_worker = Proc.new {
  puts "Proc Worker started, pid: #{me()}"
  loop {
    msg = receive
    puts "Proc worker pid: #{me()}, recv: #{msg}"
  }
}

proc_worker_args = Proc.new { |a, b|
  puts "Proc Worker started, pid: #{me()}, args: a=#{a}, b=#{b}"
  loop {
    msg = receive
    puts "Proc worker pid: #{me()}, recv: #{msg}"
  }
}

# Start Beam::Process using the Lambda
lambda_worker_pid = Beam::spawn lambda_worker, nil, []
lambda_worker_args_pid = Beam::spawn lambda_worker_args, nil, [5, 10]

# Start Beam::Process using the Proc
proc_worker_pid = Beam::spawn proc_worker, nil, []
proc_worker_args_pid = Beam::spawn proc_worker_args, nil, [5, 10]

sleep 1
puts '-'*5

# Send them messages
Beam::msg lambda_worker_pid, "hello"
Beam::msg lambda_worker_args_pid, "hello"
Beam::msg proc_worker_pid, "hello"
Beam::msg proc_worker_args_pid, "hello"

sleep 2
puts '--- bye ---'
