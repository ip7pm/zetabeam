module Beam

  class Process
    @processes = {}

    def self.spawn(klass, method, args)
      # Generate a PID
      # TODO: Make sure the pid does not already exists (must be unique)
      pid = "#PID<0.#{rand(0..500)}.#{rand(0..500)}>"

      # Run klass.method in a separate thread
      ki = klass.new pid

      t = Thread.new {
        ki.send method, *args
        @processes.delete pid
      }

      # Maintain the list of running processes
      @processes.store pid, [ki, t]
      pid
    end

    def self.msg(pid, msg)
      # Retreive the process
      info = @processes[pid]
      if info.nil?
        # TODO: What to do if process does not exists
        raise "The process pid: #{pid} does not exists"
      else
        # Send message
        ki, _t = info
        ki.push_msg_in_mailbox msg
      end
    end

  end

end
