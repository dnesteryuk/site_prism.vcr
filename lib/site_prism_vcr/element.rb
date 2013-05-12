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
      end

      def click_and_apply_vcr(custom_fixtures = [], action = :replace, &block)
        options = @options.dup_without_fixtures

        adjuster = Adjuster.new(
          options,
          @fixtures_handler
        )

        unless block_given?
          block = lambda do |*|
            fixtures custom_fixtures
            public_send(action)
          end
        end

        adjuster.instance_eval &block
        adjuster.modify_fixtures

        self.click

        @waiter = Waiter.new(@parent, options)
        @waiter.wait
      end
    end
  end
end