require 'delegate'

module SitePrism
  module Vcr
    class Element < SimpleDelegator
      def initialize(element, parent, raw_options = {}, &block)
        super element

        @applier = Applier.new(parent, raw_options, &block)
      end

      def click_and_apply_vcr(&adjusting_block)
        @applier.apply(adjusting_block) do
          click
        end
      end
    end
  end
end