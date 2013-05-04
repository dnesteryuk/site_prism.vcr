module SitePrism
  module Vcr
    module PathCombiner
      attr_reader :fixtures

      def path(path, fixture_names)
        @fixtures = [] if @fixtures.nil?

        fixture_names.map do |name|
          @fixtures << "#{path}/#{name}"
        end
      end
    end
  end
end