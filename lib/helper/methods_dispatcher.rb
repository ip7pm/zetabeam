module Beam
  module Helper
    module MethodsDispatcher
      def run()
        loop {
          method, args = receive
          if respond_to? method
            send method, *args
          else
            puts "Process, pid #{@pid}: Unknown method: #{method}"
          end
        }
      end
    end
  end
end
