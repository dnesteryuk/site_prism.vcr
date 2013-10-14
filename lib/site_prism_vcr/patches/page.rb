module SitePrism
  class Page
    # TODO: it should make sure this method does not a native method of SitePrism::Page class
    def self.inherited(subclass)
      # This code is required to allow subpages to inherit
      # a defined adjuster block. Otherwise, that block should be
      # duplicated in a subpage as well.
      subclass.instance_variable_set(:@vcr_adjuster, @vcr_adjuster)
    end

    def self.vcr_options_for_load(&block)
      @vcr_adjuster = block
    end

    def self.vcr_adjuster
      @vcr_adjuster
    end

    def apply_vcr(*args, action_block, &adjusting_block)
      applier = SPV::Applier.new(
        self,
        &self.class.vcr_adjuster
      )

      applier.apply(
        adjusting_block
      ) do
        action_block.call
      end
    end

    def load_and_apply_vcr(*args, &adjusting_block)
      action_block = proc { load(*args) }

      apply_vcr(
        action_block,
        &adjusting_block
      )
    end
  end
end