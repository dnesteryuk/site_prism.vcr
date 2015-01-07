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

    # Stores a block with an action (click, scroll down, mouse over etc)
    # VCR should be applied on.
    #
    # This block will be called over an object VCR linked to.
    #
    #  Example:
    #    @my_element.shift_event do
    #      self.click
    #    end
    #
    # @param block [Proc]
    #
    # @return [SPV::Applier] The current applier object.
    #
    # @api public
    def shift_event(&block)
      @event_action = block

      self
    end

    # Alters default fixtures and options.
    #
    # @param adjusting_block [Proc] It allows to
    #  change fixtures through DSL (@see SPV::DSL::InitialAdjuster
    #  and @see SPV::DSL::Adjuster)
    #
    # @return [void]
    #
    # @api public
    def alter_fixtures(&block)
      @fixtures = adjust_fixtures(
        @options, &block
      )
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
    #
    # @api public
   def apply_vcr(&block)
      verify_define_event!

      fixtures, options = @fixtures, @options.clone_options

      if block_given?
        fixtures = adjust_fixtures(options, &block)
      end

      fixtures_manager = Fixtures::Manager.inject(
        fixtures, options
      )

      @event_action.call

      Waiter.wait(
        @node,
        fixtures_manager,
        options
      )
    end

    private
      def verify_define_event!
        raise EventError.new(
          'Event is not shifted, before applying VCR you have to shift event with "shift_event" method'
        ) if @event_action.nil?
      end

      def adjust_fixtures(options, &block)
        adjuster = DSL::Adjuster.new(
          options,
          @fixtures
        )

        adjuster.instance_eval &block

        adjuster.prepare_fixtures
      end
  end # class Applier
end # module SPV