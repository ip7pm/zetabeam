require_relative './spawnable'
require_relative './process'

module Beam

  def self.spawn(klass, method, args)
    Beam::Process::spawn klass, method, args
  end

  def self.msg(pid, msg)
    Beam::Process::msg pid, msg
  end

  def self.me()           # i.e  self() in Elixir
    # TODO: Think about the main process PID value
    "#PID<0.0.0>"
  end
end
