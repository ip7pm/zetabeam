module Beam

  class Spawnable
    attr_reader :pid

    def initialize(pid)
      @pid = pid
      @mailbox = Queue.new
      @flags = {
        # TODO: Implement :priority flag
        trap_exit: false,
      }
    end

    def flag(flag, value)
      if flag == :trap_exit
        raise(ArgumentError, 'Value must be a Boolean') unless [TrueClass, FalseClass].include?(value.class)
        old = @flags[flag]
        @flags.store flag, value
        old
      else
        raise ArgumentError, "Only flag ':trap_exit' supported" 
      end
    end

    def trap_exit?()
      @flags[:trap_exit]
    end

    def me()
      @pid
    end

    def receive()
      @mailbox.pop
    end

    def msg(pid, msg)
      Beam::Actor::msg pid, msg
    end

    def spawn(klass, method, args)
      Beam::Actor::spawn klass, method, args
    end

    def push_msg_in_mailbox(msg)
      @mailbox.push msg
    end
  end
end
