module Beam

  class Actor
    # NOTE: The PID of the main actor must be in the list
    @actors = {"#PID<0.0.0>" => []}
    @registers = {}

    class << self
      def list()
        @actors.keys()
      end

      def alive?(pid)
        info = @actors[pid]
        return false if info.nil?
        _ki, t = info
        t.alive?
      end

      def spawn(klass, method, args)
        # Generate a PID
        # TODO: Make sure the pid does not already exists (must be unique)
        pid = "#PID<0.#{rand(1..500)}.#{rand(0..500)}>"

        # Run klass.method in a separate thread
        ki = klass.new pid

        t = Thread.new {
          ki.send method, *args
          @actors.delete pid
        }

        # Maintain the list of running actors
        @actors.store pid, [ki, t]
        # TODO: (T1) Remove Actor from @registers if it is registered
        pid
      end

      def msg(pid_or_name, msg)
        # If it's a registered name instead of normal pid
        pid = pid_or_name.is_a?(Symbol) ? get_registered_pid(pid_or_name) : pid_or_name

        # Retreive the actor
        info = @actors[pid]
        if info.nil?
          # TODO: (T3) What to do if actor does not exists
          raise "The actor pid: #{pid} does not exists"
        else
          # Send message
          ki, _t = info
          ki.push_msg_in_mailbox msg
        end
      end

      def register(pid, name)
        raise ArgumentError, "Name must be a Symbol" unless name.is_a? Symbol
        raise ArgumentError, "Name: #{name} already taken" if @registers.has_key? name
        raise ArgumentError, "Actor pid: #{pid} is not alive" unless alive? pid
        @registers.store name, pid
      end

      def unregister(name)
        raise ArgumentError, "Name must be a Symbol" unless name.is_a? Symbol
        raise ArgumentError, "Cannot unregister name: #{name}" unless @registers.has_key? name
        @registers.delete name
      end

      def registered()
        @registers.keys()
      end

      def registered?(name)
        raise ArgumentError, "Name must be a Symbol" unless name.is_a? Symbol
        @registers.has_key? name
      end

      def get_registered_pid(name)
        raise ArgumentError, "Name must be a Symbol" unless name.is_a? Symbol
        raise ArgumentError, "Name: #{name} is not registered" unless @registers.has_key? name
        @registers[name]
      end
    end
  end

end
