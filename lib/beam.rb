require_relative './spawnable'
require_relative './process'

module Beam

  def self.spawn(klass, method, args)
    Beam::Process::spawn klass, method, args
  end

  def self.msg(pid, msg)
    Beam::Process::msg pid, msg
  end

end
