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

      def apply(custom_fixtures = nil, action = nil, adjusting_block = nil)
        custom_fixtures ||= []
        action ||= :replace

        options = @options.dup_without_fixtures

        adjuster = Adjuster.new(
          options,
          @fixtures
        )

        if adjusting_block.nil?
          adjusting_block = lambda do |*|
            fixtures custom_fixtures
            public_send(action)
          end
        end

        adjuster.instance_eval &adjusting_block

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