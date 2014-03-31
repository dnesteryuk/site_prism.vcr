module SPV
  # Converts list with fixture names into list of
  # SPV::Fixture objects.
  class Fixtures
    class Converter
      def self.convert_raw(raw_list)
        raw_list.map do |item|
          if item.kind_of?(String)
            Fixture.new(item)
          else
            Fixture.new(item[:fixture], item[:options])
          end
        end
      end
    end # class Converter
  end # class Fixtures
end # module SPV