require 'delegate'
require 'forwardable'

module SPV
  # Extends a native Capybara element with new methods.
  class Element < SimpleDelegator
    extend Forwardable

    def_delegator :@applier, :shift_event

    def initialize(element, parent, &block)
      super element

      @applier = Applier.new(parent, &block)
    end

    def click_and_apply_vcr(&block)
      shift_event { click }.apply_vcr(&block)
    end
  end
end
