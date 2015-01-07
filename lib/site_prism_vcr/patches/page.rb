require 'forwardable'

module SitePrism
  class Page
    extend Forwardable

    def_delegator :@applier, :shift_event

    class << self
      @vcr_parent_adjusters = []

      attr_reader :vcr_parent_adjusters

      def inherited(subclass)
        # This code is required to allow subpages to inherit
        # a defined adjuster block. Otherwise, that block should be
        # duplicated in a subpage as well.
        subclass.instance_variable_set(:@vcr_adjuster,         @vcr_adjuster)
        subclass.instance_variable_set(:@vcr_parent_adjusters, @vcr_parent_adjusters)
      end

      def vcr_options_for_load(&block)
        @vcr_adjuster = block
      end

      def adjust_parent_vcr_options(&block)
        raise 'There is not any adjuster block' unless @vcr_adjuster

        @vcr_parent_adjusters << block
      end

      def vcr_adjuster
        @vcr_adjuster
      end
    end

    def initialize(*args)
      super

      @applier = SPV::Applier.new(
        self,
        &self.class.vcr_adjuster
      )

      # @vcr_parent_adjusters.each do |block|
      #   @applier.alter_fixtures(&block)
      # end
    end

    def load_and_apply_vcr(*args, &block)
      shift_event { load(*args) }.apply_vcr(&block)
    end
  end
end