module SitePrism
  module Vcr
    class FixturesHandler
      attr_reader :fixtures

      def initialize(options)
        @fixtures, @options = options.fixtures, options
      end

      def fixtures
        wrong_fixtures = []

        prepared_fixtures = @fixtures.map do |fixture|
          if fixture[0..1] == '~/'
            if @options.home_path
              fixture = fixture.gsub(/\A\~\//, @options.home_path)
            else
              wrong_fixtures << fixture
            end
          end

          fixture
        end

        if wrong_fixtures.size > 0
          raise ArgumentError.new(
            "You are trying to use a home path for these: #{wrong_fixtures.join(', ')} fixtures. " \
            "They cannot be used since the home_path is not defined, please refer to the documentation " \
            "to make sure you define the home path properly."
          )
        else
          prepared_fixtures
        end
      end

      def clean_fixtures
        @fixtures = []
      end

      def add_fixtures(new_fixtures)
        @fixtures.concat(new_fixtures)
      end
    end
  end
end