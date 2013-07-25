module SPV
  # Converts raw fixtures into list of
  # SPV::Fixture objects, applies modifiers after converting
  class Fixtures
    class Converter
      def initialize(options)
      end

      def convert_raw(raw_list)
        raw_list.map do |item|
          if item.kind_of?(String)
            Fixture.new(item)
          else
            Fixture.new(item[:fixture], item[:options])
          end
        end
      end
    end
  end
end