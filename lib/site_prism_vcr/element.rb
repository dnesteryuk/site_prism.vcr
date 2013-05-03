require 'delegate'

module SitePrism
  module Vcr
    class Element < SimpleDelegator
      # TODO: it should raise an error if a hash is passed and
      # a block as well
      def initialize(element, parent, raw_options = {}, &block)
        super element

        @parent, @options = parent, Options.new(raw_options)

        if block_given?
          adjuster = InitialAdjuster.new(@options)
          adjuster.instance_eval &block
        end

        @fixtures_handler = FixturesHandler.new(@options)
        @waiter           = Waiter.new(parent, @options)
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
          adjuster = Adjuster.new(@fixtures_handler, @options)
          adjuster.instance_eval &block
          adjuster.modify_fixtures

          @waiter.waiter = adjuster.waiter
        end
    end
  end
end