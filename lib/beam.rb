require_relative './spawnable'
require_relative './actor'
require_relative './helper/methods_dispatcher'

module Beam
  @mailbox = Queue.new

  def self.spawn(klass, method, args)
    Beam::Actor::spawn klass, method, args
  end

  def self.msg(pid, msg)
    Beam::Actor::msg pid, msg
  end

  def self.me()           # i.e  self() in Elixir
    # TODO: (T2) Think about the main actor PID value
    "#PID<0.0.0>"
  end

  def self.receive()
    @mailbox.pop
  end

  def self.push_msg_in_mailbox(msg)
    @mailbox.push msg
  end
end
