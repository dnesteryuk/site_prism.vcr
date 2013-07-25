module SPV
  class Fixtures
    # This class is responsible for keeping a list
    # of prepared fixtures which will be inserted to Vcr.
    class TmpKeeper
      attr_reader :fixtures

      def initialize(options)
        @fixtures, @options = [], options
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
