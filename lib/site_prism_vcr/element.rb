require 'delegate'

module SitePrism
  module Vcr
    class Element < SimpleDelegator
      def initialize(element, parent, options = {})
        super element

        @parent, @options = parent, options

        @fixtures_handler = FixturesHandler.new options
      end

      def click_and_apply_vcr(*args, &block)
        @fixtures_handler.apply *args

        if block_given?
          adjust_fixtures &block
        end

        self.click

        # TODO: apply Null object pattern
        if @options[:waiter]
          @parent.public_send @options[:waiter]
        end
      end

      protected
        def adjust_fixtures(&block)
          adjuster = FixturesAdjuster.new @fixtures_handler
          adjuster.instance_eval &block
        end
    end
  end
end