# TODO: this class should be splitted onto 2 since it takes care about
# 2 responsibilities
module SitePrism
  module Vcr
    # This class is responsible for keeping a list
    # of prepared fixtures to be inserted into VCR
    class FixturesHandler
      attr_reader :fixtures

      def initialize(options)
        @fixtures, @options = options.fixtures, options
      end

      def fixtures(raw_fixtures = nil)
        wrong_fixtures = []

        raw_fixtures ||= @fixtures

        prepared_fixtures = raw_fixtures.map do |fixture|
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
