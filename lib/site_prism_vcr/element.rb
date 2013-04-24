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
          @adjuster = FixturesAdjuster.new @fixtures_handler, @options

          adjust_fixtures &block

          @waiter.waiter = @adjuster.waiter
        else
          @fixtures_handler.apply *args
        end

        self.click

        @waiter.wait
      end

      protected
        def adjust_fixtures(&block)
          @adjuster.instance_eval &block
          @adjuster.modify_fixtures
        end
    end
  end
end