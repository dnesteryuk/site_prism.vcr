require 'delegate'

module SitePrism
  module Vcr
    class Element < SimpleDelegator
      def initialize(element, parent, options = {})
        super element

        @parent  = parent
        @options = options

        @fixtures_handler = FixturesHandler.new(
          options
        )
      end

      def click_and_apply_vcr(*args)
        @fixtures_handler.apply(*args)

        self.click

        # TODO: apply Null object pattern
        if @options[:waiter]
          @parent.public_send(@options[:waiter])
        end
      end
    end
  end
end