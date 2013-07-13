module SitePrism
  class Page
    def self.vcr_options_for_load(&block)
      @vcr_adjuster = block
    end

    def self.vcr_options
      @vcr_options
    end

    def self.vcr_adjuster
      @vcr_adjuster
    end

    def apply_vcr(*args, action_block, &adjusting_block)
      applier = SitePrism::Vcr::Applier.new(
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