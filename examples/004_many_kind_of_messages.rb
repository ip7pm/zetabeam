require_relative '../lib/beam'

class Worker < Beam::Spawnable
  def run()
    puts "Worker started, pid: #{me()}"
    loop {
      case receive
      in [:msg, data] then
        puts "Worker pid: #{me()}, recv: #{data}"

      in [:add, a, b] then
        puts "Worker pid: #{me()}, add: #{a} + #{b} = #{a + b}"

      in [:sub, a, b] if a.is_a? Integer and b.is_a? Integer
        puts "Worker pid: #{me()}, sub: #{a} - #{b} = #{a - b}"

      else
        puts "Worker pid: #{me()}, recv: Unknown message"
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
puts ''
Beam::msg pid, [:unknown, 'bad message']    # Will not pattern match
sleep 1
Beam::msg pid, [:sub, 'hello', 'world']     # Will not pattern match
sleep 1

# And the Actor is still alive
puts ''
puts "Actor pid: #{pid} is alive?: #{Beam::Actor::alive? pid}"

puts '--- bye ---'

