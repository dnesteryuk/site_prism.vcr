module SitePrism
  module Vcr
    class Waiter
      attr_reader :waiter_method, :node

      def initialize(node, options)
        @node, @waiter_method = node, options.waiter
      end

      def wait
        if waiter_method
          @node.public_send waiter_method
        end
      end

      def with_new_options(options)
        self.class.new(@node, options)
      end
    end
  end
end