require 'pathname'

module SPV
  # Keeps a path to a fixture and options which should be
  # passed to Vcr while inserting a cassette
  class Fixture
    attr_accessor :options, :path

    def initialize(name, vcr_options = {})
      path = Pathname.new(name)

      @fixture_name = path.basename
      @path         = path.dirname
      @options      = vcr_options
    end

    def name
      (self.path + @fixture_name).to_path
    end

    def path=(val)
      @path = Pathname.new(val)
    end

    def set_home_path(home_path)
      self.path = self.path.to_path.gsub(/\A(\~\/|\~)/, home_path)
    end

    def has_link_to_home_path?
      self.name[0..1] == '~/'
    end

    # Returns a name without a link to a home path
    def clean_name
      @fixture_name.to_path
    end
  end # class Fixture
end # module SPV