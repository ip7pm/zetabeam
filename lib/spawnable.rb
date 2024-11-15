module Beam

  class Spawnable
    attr_reader :pid

    def initialize(pid)
      @pid = pid
      @mailbox = Queue.new
    end

    def receive()
      @mailbox.pop
    end

    def push_msg_in_mailbox(msg)
      @mailbox.push msg
    end
  end

end
