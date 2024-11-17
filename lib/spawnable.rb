module Beam

  class Spawnable
    attr_reader :pid

    def initialize(pid)
      @pid = pid
      @mailbox = Queue.new
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
