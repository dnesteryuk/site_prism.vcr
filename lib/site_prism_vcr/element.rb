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
      def click_and_apply_fixtures(custom_fixtures = [], behavior = :union)
        @fixtures_handler.apply(custom_fixtures, behavior)

        origin_synchronize { base.click }
      end

      alias_method :click_and_apply_fixture, :click_and_apply_fixtures
    end
  end
end