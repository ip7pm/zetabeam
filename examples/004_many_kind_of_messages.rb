require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{me()}"
    loop {
      msg = receive
      case msg
      in [:msg, data] if data.is_a? String
        puts "Worker pid: #{me()}, recv: #{data}"

      in [:add, a, b] then
        puts "Worker pid: #{me()}, add: #{a} + #{b} = #{a + b}"

      in [:sub, a, b] if a.is_a? Integer and b.is_a? Integer
        puts "Worker pid: #{me()}, sub: #{a} - #{b} = #{a - b}"

      in {op: :mul, a: a, b: b} if a.is_a? Integer and b.is_a? Integer
        puts "Worker pid: #{me()}, mul: #{a} * #{b} = #{a * b}"

      else
        puts "Worker pid: #{me()}, recv: Unknown message"
        p msg
      end
    }
  end
end

# Start a Actor running the Worker.run()
pid = Beam::spawn Worker, :run, []

# Send messages to the Actor using his pid
Beam::msg pid, [:msg, 'hello world']
sleep 1
Beam::msg pid, [:add, 12, 34]
sleep 1
Beam::msg pid, [:add, 'hello', ' world']
sleep 1
Beam::msg pid, [:sub, 72, 21]
sleep 1
Beam::msg pid, {op: :mul, a: 10, b: 2}
sleep 1
puts '-'*5
Beam::msg pid, [:msg, 21]
sleep 1
Beam::msg pid, [:sub, 'hello', 21]     # Will not pattern match
sleep 1
Beam::msg pid, [:unknown, 'bad message']    # Will not pattern match
sleep 1

# And the Actor is still alive
puts ''
puts "Actor pid: #{pid} is alive?: #{Beam::Actor::alive? pid}"

puts '--- bye ---'

