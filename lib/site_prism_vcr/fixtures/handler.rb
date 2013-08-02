module SPV
  class Fixtures
    # Prepares incoming raw fixtures to be used for inserting
    # into VCR
    class Handler
      def initialize(options, convertor = Converter)
        @options = options

        @converter = convertor
      end

      def handle_raw(raw_fixtures, modifiers)
        converted_fixtures = @converter.convert_raw(raw_fixtures)

        modifiers.map do |modifier|
          converted_fixtures.each do |converted_fixture|
            modifier.modify(converted_fixture)
          end
        end

        converted_fixtures
      end
    end
  end
end