module Beam::Helper
  module MethodsDispatcher
    def run()
      loop {
        case receive
        in [method, args] if method.is_a? Symbol and args.is_a? Array
          if respond_to? method
            send method, *args
          else
            # TODO: (T4) Raise an exception ? (if linked or monitored ?)
            raise "Undefined method: #{method}"
          end
        else
          # TODO: (T4) Raise an exception ? (if linked or monitored ?)
          raise "Process, pid #{me()}: Unknown message"
        end
      }
    end
  end
end
