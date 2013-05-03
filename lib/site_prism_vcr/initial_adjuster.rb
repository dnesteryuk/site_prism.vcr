module SitePrism
  module Vcr
    class InitialAdjuster
      def initialize(options)
        @options = options
      end

      def fixtures(val)
        @options.fixtures = val
      end

      # TODO: this method is almost the same with the previous one
      # think about refactoring it
      def waiter(val)
        @options.waiter = val
      end
    end
  end
end