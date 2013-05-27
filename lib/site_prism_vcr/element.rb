require 'delegate'

module SitePrism
  module Vcr
    class Element < SimpleDelegator
      def initialize(element, parent, raw_options = {}, &block)
        super element

        @applier = Applier.new(parent, raw_options, &block)
      end

      def click_and_apply_vcr(custom_fixtures = nil, action = nil, &adjusting_block)
        @applier.apply(
          custom_fixtures,
          action,
          adjusting_block
        ) do
          click
        end
      end
    end
  end
end