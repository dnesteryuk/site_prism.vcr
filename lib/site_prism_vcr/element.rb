require 'delegate'

module SPV
  # Extends a native Capybara element with new methods.
  class Element < SimpleDelegator
    def initialize(element, parent, &block)
      super element

      @applier = Applier.new(parent, &block)
    end

    def click_and_apply_vcr(&block)
      shift_event { click }.apply_vcr &block
    end

    def shift_event(&block)
      @applier.shift_event(&block)
    end
  end
end
