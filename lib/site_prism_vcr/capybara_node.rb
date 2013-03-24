module Capybara
  module Node
    class Element

      alias :origin_synchronize :synchronize

      def synchronize(*args, &block)
        res = origin_synchronize *args, &block

        eject_vcr_cassettes

        res
      end

      private
        def eject_vcr_cassettes
          while VCR.eject_cassette
          end
        end
    end
  end
end