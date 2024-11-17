module Beam

  class Actor
    # NOTE: The PID of the main actor must be in the list
    @actors = {"#PID<0.0.0>" => []}

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
        pid = "#PID<0.#{rand(0..500)}.#{rand(0..500)}>"

        # Run klass.method in a separate thread
        ki = klass.new pid

        t = Thread.new {
          ki.send method, *args
          @actors.delete pid
        }

        # Maintain the list of running actors
        @actors.store pid, [ki, t]
        pid
      end

      def msg(pid, msg)
        # Retreive the actor
        info = @actors[pid]
        if info.nil?
          # TODO: What to do if actor does not exists
          raise "The actor pid: #{pid} does not exists"
        else
          # Send message
          ki, _t = info
          ki.push_msg_in_mailbox msg
        end
      end
    end
  end

end
