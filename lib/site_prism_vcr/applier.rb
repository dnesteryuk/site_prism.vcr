module SitePrism
  module Vcr
    class Applier
      def initialize(node, &block)
        @node, @options = node, Options.new
        adjuster = InitialAdjuster.new(@options)

        adjuster.instance_eval &block

        @fixtures = adjuster.prepared_fixtures

        @fixtures_manager = FixturesManager.new(@options)
      end

      # Applies fixtures to be used for stubbing HTTP interactions
      # caused by an event (click on an element or page loading).
      #
      # @param adjusting_block [nil, Proc] If an adjusting block is given,
      #  it allows to change fixtures through DSL (@see SitePrism::Vcr::Adjuster)
      #
      # @return [void]
      def apply(adjusting_block = nil)
        options = @options.dup_without_fixtures

        adjuster = Adjuster.new(
          options,
          @fixtures
        )

        if adjusting_block
          adjuster.instance_eval &adjusting_block
        end

        @fixtures_manager.inject(adjuster.prepared_fixtures)

        yield

        @waiter = Waiter.new(
          @node,
          @fixtures_manager,
          options
        )

        @waiter.wait
      end
    end
  end
end