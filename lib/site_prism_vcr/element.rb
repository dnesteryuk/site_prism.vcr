require 'delegate'

module SPV
  # Extends a native Capybara element with new methods.
  class Element < SimpleDelegator
    def initialize(element, parent, &block)
      super element

      @applier = Applier.new(parent, &block)
    end

    def click_and_apply_vcr(&adjusting_block)
      apply_vcr( -> {click}, &adjusting_block )
    end

    def apply_vcr(action_block, &adjusting_block)
      @applier.apply(adjusting_block, &action_block)
    end
  end
end
