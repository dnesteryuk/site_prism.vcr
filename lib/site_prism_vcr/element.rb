require 'delegate'

module SitePrism
  module Vcr
    class Element < SimpleDelegator
      attr_reader :options

      def initialize(element, options = {})
        super element

        @fixtures_handler = FixturesHandler.new(options[:fixtures])

        @options = options
      end

      # TODO: find the way not to duplicate arguments here. Because,
      # the same arguments are specified for +apply+ method of FixturesHandler
      # TODO: the previousle added custom fixtures must be removed once new one are added
      def click_and_apply_vcr(custom_fixtures = [], behavior = :union)
        @fixtures_handler.apply(custom_fixtures, behavior)

        self.click
      end
    end
  end
end