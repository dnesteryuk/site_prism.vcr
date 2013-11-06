module SPV
  # This class manages defining default fixtures
  # and applying them on an event.
  class Applier
    def initialize(node, &block)
      @node, @options = node, Options.new
      adjuster = DSL::InitialAdjuster.new(@options)

      if block_given?
        adjuster.instance_eval &block
      end

      @fixtures = adjuster.prepared_fixtures

      @fixtures_manager = Fixtures::Manager.new(@options)
    end

    def shift_event(&block)
      @event_action = block

      self
    end

    # Applies fixtures to be used for stubbing HTTP interactions
    # caused by an event (click on an element or page loading).
    #
    # Makes a defined waiter to meet expectation before ejecting
    # fixtures from VCR.
    #
    # @param adjusting_block [nil, Proc] If an adjusting block is given,
    #  it allows to change fixtures through DSL (@see SPV::DSL::InitialAdjuster
    #  and @see SPV::DSL::Adjuster)
    #
    # @return [void]
    def apply(&block)
      options = @options.clone_options

      adjuster = DSL::Adjuster.new(
        options,
        @fixtures
      )

      if block_given?
        adjuster.instance_eval &block
      end

      @fixtures_manager.inject(adjuster.prepared_fixtures)

      @event_action.call

      @waiter = Waiter.new(
        @node,
        @fixtures_manager,
        options
      )

      @waiter.wait
    end
  end
end