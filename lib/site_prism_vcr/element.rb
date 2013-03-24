require 'delegate'

module SitePrism
  module Vcr
    class Element < SimpleDelegator
      attr_reader :options

      def initialize(element, options = {})
        super element

        @options = options
      end

      # TODO: it should allow to join fixtures without overriding the whole list
      def click_and_apply_fixtures(fixtures = nil)
        apply_fixtures(fixtures || options[:fixtures])

        origin_synchronize { base.click }
      end

      alias :click_and_apply_fixture :click_and_apply_fixtures

      private
        def apply_fixtures(fixtures)
          fixtures.map do |fixture|
            VCR.insert_cassette fixture
          end
        end
    end
  end
end