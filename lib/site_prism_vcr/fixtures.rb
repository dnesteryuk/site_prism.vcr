module SPV
  # This class is a container for keeping all prepared fixtures for inserting
  # into VCR.
  class Fixtures
    include Enumerable

    def initialize(vals)
      @container = vals.each_with_object({}) do |fixture, memo|
        memo[fixture.name] = fixture
      end
    end

    def exchange(old_vals, new_vals)
      new_list = self.each_with_object([]) do |item, memo|
        memo << item unless old_vals.any? {|old_item| item.name == old_item.name }
      end

      self.class.new(new_list.concat(new_vals))
    end

    def replace(vals)
      if vals.length > 0
        self.class.new(vals)
      else
        self
      end
    end

    def union(vals)
      self.class.new(@container.values.concat(vals))
    end

    def each(&block)
      @container.values.each &block
    end

    def size
      @container.values
    end
  end # class Fixtures
end # module SPV