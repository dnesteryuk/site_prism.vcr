require 'delegate'

module SitePrism
  module Vcr
    class Element < SimpleDelegator
      def initialize(element, parent, options = {})
        super element

        @parent, @options = parent, options

        @fixtures_handler = FixturesHandler.new options
        @waiter           = Waiter.new parent, options
      end

      def click_and_apply_vcr(*args, &block)
        if block_given?
          adjust_fixtures &block
        else
          @fixtures_handler.apply *args
        end

        self.click

        @waiter.wait
      end

      protected
        def adjust_fixtures(&block)
          adjuster = FixturesAdjuster.new @fixtures_handler, @options
          adjuster.instance_eval &block
          adjuster.modify_fixtures

          @waiter.waiter = adjuster.waiter
        end
    end
  end
end