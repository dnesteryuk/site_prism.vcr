# TODO: should be this class immutable?
module SitePrism
  module Vcr
    class Options
      attr_accessor :fixtures, :waiter, :home_path

      def initialize(options = {})
        check_options options

        @fixtures = []

        options.each do |key, val|
          public_send("#{key}=", val)
        end
      end

      def home_path=(val)
        val << '/' unless val[-1, 1] == '/'

        @home_path = val
      end

      def fixtures
        wrong_fixtures = []

        prepared_fixtures = @fixtures.map do |fixture|
          if fixture[0..1] == '~/'
            if home_path
              fixture = fixture.gsub(/\A\~\//, home_path)
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

      def dup_without_fixtures
        new_options = dup
        new_options.fixtures = []
        new_options
      end

      def add_fixtures(new_fixtures)
        @fixtures.concat(new_fixtures)
      end

      protected
        def check_options(options)
          keys = options.keys.map(&:to_sym) - [:fixtures, :waiter]

          if keys.size > 0
            if keys.size == 1
              part, opt_end = 'is', ''
            else
              part, opt_end = 'are', 's'
            end

            keys.map!{|key| "'#{key}'" }

            msg = "#{keys.join(', ')} #{part} not known option#{opt_end} for handling Vcr fixtures"

            raise ArgumentError.new(msg)
          end
        end
    end
  end
end