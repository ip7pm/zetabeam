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
            puts "Actor, pid #{me()}: Unknown method: #{method}"
          end
        else
            # TODO: (T4) Raise an exception ? (if linked or monitored ?)
          puts "Actor, pid #{me()}: Unknown message"
        end
      }
    end
  end
end
