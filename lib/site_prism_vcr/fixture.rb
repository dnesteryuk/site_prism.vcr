module SPV
  # Keeps a path to fixture and options which should be
  # passed to Vcr while inserting a cassette
  class Fixture
    attr_accessor :name, :options

    def initilize(attrs)
      @name    = attrs[:name]
      @options = attrs.fetch(:options, {})
    end
  end
end