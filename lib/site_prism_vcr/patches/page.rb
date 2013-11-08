require 'forwardable'

module SitePrism
  class Page
    extend Forwardable

    def_delegator :@applier, :shift_event

    class << self
      # TODO: it should make sure this method does not a native method of SitePrism::Page class
      def inherited(subclass)
        # This code is required to allow subpages to inherit
        # a defined adjuster block. Otherwise, that block should be
        # duplicated in a subpage as well.
        subclass.instance_variable_set(:@vcr_adjuster, @vcr_adjuster)
      end

      def vcr_options_for_load(&block)
        @vcr_adjuster = block
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
    end

    def load_and_apply_vcr(*args, &block)
      shift_event { load(*args) }.apply_vcr(&block)
    end
  end
end