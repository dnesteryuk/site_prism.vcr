module SPV
  # This class manages defining default fixtures
  # and applying them on an event.
  class Applier
    class EventError < StandardError; end

    def initialize(node, &block)
      @node, @options = node, Options.new
      adjuster = DSL::InitialAdjuster.new(@options)

      if block_given?
        adjuster.instance_eval &block
      end

      @fixtures = adjuster.prepare_fixtures
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
    def apply_vcr(&block)
      verify_define_event!

      options = @options.clone_options

      adjuster = DSL::Adjuster.new(
        options,
        @fixtures
      )

      if block_given?
        adjuster.instance_eval &block
      end

      @fixtures_manager = Fixtures::Manager.new(
        adjuster.prepare_fixtures, @options
      )

      @fixtures_manager.inject

      @event_action.call

      Waiter.wait(
        @node,
        @fixtures_manager,
        options
      )
    end

    private
      def verify_define_event!
        raise EventError.new(
          'Event is not shifted, before applying Vcr you have to shift event with "shift_event" method'
        ) if @event_action.nil?
      end
  end # class Applier
end # module SPV