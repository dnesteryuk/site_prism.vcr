module SitePrism
  module Vcr
    class Waiter
      attr_accessor :waiter

      def initialize(node, options)
        @node, @waiter = node, options.waiter
      end

      def wait
        if waiter
          @node.public_send waiter
        end
      end
    end
  end
end