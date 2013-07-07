module SitePrism
  module Vcr
    class Applier
      # TODO: it should raise an error if a hash is passed and
      # a block as well
      def initialize(node, raw_options = {}, &block)
        @node, @options = node, Options.new(raw_options)
        adjuster = InitialAdjuster.new(@options)

        if block_given?
          adjuster.instance_eval &block
        end

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