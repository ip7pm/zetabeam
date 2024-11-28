module Beam

  class Process
    # NOTE: The PID of the main process must be in the list
    @processes = {"#PID<0.0.0>" => []}
    @registers = {}

    class << self
      def list()
        @processes.keys()
      end

      def alive?(pid)
        info = @processes[pid]
        return false if info.nil?
        _ki, t = info
        t.alive?
      end

      def spawn(klass, method, args)
        # Generate a PID
        # TODO: Make sure the pid does not already exists (must be unique)
        pid = "#PID<0.#{rand(1..500)}.#{rand(0..500)}>"

        if klass.is_a? Proc
          raise ArgumentError, "Cannot use 'method' argument with lambda or proc" unless method.nil?
          ki = SpawnableProc.new pid
          ki.encapsulate_proc klass
          method = :run
        else
          ki = klass.new pid
        end

        # Run klass.method in a separate thread
        t = Thread.new {
          begin
            ki.send method, *args
          rescue => e
            # TODO: (T6) Here is something to handle if the Process is linked or monitored
            puts "Process pid, #{pid}, crashed with msg: #{e.message}"
          ensure
            @processes.delete pid
            if @registers.has_value? pid
              name = @registers.key pid
              @registers.delete name
            end
          end
        }

        # Maintain the list of running processes
        @processes.store pid, [ki, t]
        pid
      end

      def msg(pid_or_name, msg)
        # If it's a registered name instead of normal pid
        pid = pid_or_name.is_a?(Symbol) ? get_registered_pid(pid_or_name) : pid_or_name

        # Particular case if the message is send to the main ruby process
        # Main process act like an Process with harcoded pid: #PID<0.0.0>
        if pid == Beam::me()
          Beam::push_msg_in_mailbox msg
          return
        end

        # Retreive the process
        info = @processes[pid]
        if info.nil?
          # TODO: (T3) What to do if process does not exists
          raise "The process pid: #{pid} does not exists"
        else
          # Send message
          ki, _t = info
          ki.push_msg_in_mailbox msg
        end

        msg
      end

      def register(pid, name)
        raise ArgumentError, "Name must be a Symbol" unless name.is_a? Symbol
        raise ArgumentError, "Name: #{name} already taken" if @registers.has_key? name
        raise ArgumentError, "Process pid: #{pid} is not alive" unless alive? pid
        raise ArgumentError, "Process pid: #{pid} is already registered" if @registers.has_value? pid
        @registers.store name, pid
      end

      def unregister(name)
        raise ArgumentError, "Name must be a Symbol" unless name.is_a? Symbol
        raise ArgumentError, "Name: #{name} is not registered" unless @registers.has_key? name
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

      def exit(sender, receiver, reason)
        info = @processes[receiver]
        if info.nil?
          # TODO: (T7) Erland/Elixir return 'true' in this case.
          # In fact it always return 'true'
          raise "The process pid: #{pid} does not exists"
        end
        ki, t = info

        if reason == :normal
          exit_normal_reason sender, receiver, ki, t
        elsif reason == :kill
          exit_kill_reason sender, receiver, ki, t
        else
          exit_any_reason sender, receiver, reason, ki, t
        end
      end


      private

        def exit_normal_reason(sender, receiver, ki, t)
          if ki.trap_exit?
            # Transform the exit signal in message {:EXIT, from, reason}
            Beam::Process::msg receiver, [:EXIT, sender, :normal]
          else
            if sender == receiver
              # Process must Exit
              do_exit sender, receiver, :normal, t
            else
              # NOTE: Nothing to do, the exit signal is ignored
            end
          end
        end

        def exit_kill_reason(sender, receiver, ki, t)
          # Process must Exit
          do_exit sender, receiver, :killed, t
        end

        def exit_any_reason(sender, receiver, reason, ki, t)
          if ki.trap_exit?
            # Transform the exit signal in message {:EXIT, from, reason}
            Beam::Process::msg receiver, [:EXIT, sender, reason]
          else
            # Process must Exit
            do_exit sender, receiver, reason, t
          end
        end

        def do_exit(sender, receiver, reason, t)
          t.exit
          @processes.delete receiver
          if @registers.has_value? receiver
            name = @registers.key receiver
            @registers.delete name
          end
          #
          # TODO: (T8) If Process is linked or monitored to other Processes we need to
          # handle it here
        end
    end
  end
end
