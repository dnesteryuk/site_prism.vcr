module SitePrism
  module Vcr
    class Waiter
      def initialize(node, fixtures_handler, options)
        @node, @waiter_method = node, options.waiter
        @fixtures_handler = fixtures_handler
        @options = options.waiter_options || {}
      end

      def wait
        if @waiter_method
          @node.instance_eval &@waiter_method

          if @options.fetch(:eject_cassettes, true)
            @fixtures_handler.eject
          end
        end
      end

      def with_new_options(options)
        self.class.new(@node, @fixtures_handler, options)
      end
    end
  end
end