module SitePrism
  module Vcr
    class Waiter
      attr_reader :waiter_method, :node

      def initialize(node, fixtures_handler, options)
        @node, @waiter_method = node, options.waiter
        @fixtures_handler = fixtures_handler
      end

      def wait
        if waiter_method
          @node.public_send waiter_method
          @fixtures_handler.eject
        end
      end

      def with_new_options(options)
        self.class.new(@node, @fixtures_handler, options)
      end
    end
  end
end