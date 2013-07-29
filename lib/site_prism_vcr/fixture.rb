module SPV
  # Keeps a path to fixture and options which should be
  # passed to Vcr while inserting a cassette
  class Fixture
    attr_accessor :name, :options

    # TODO: may be it makes sense to separately keep path from the name of a fixture?
    def initialize(name, vcr_options = {})
      @name, @options = name, vcr_options
    end

    def add_path(path)
      self.name = path + name
    end

    def set_home_path(home_path)
      self.name = self.name.gsub(/\A\~\//, home_path)
    end

    def has_link_to_home_path?
      self.name[0..1] == '~/'
    end

    # Returns a name without a link to a home path
    def clean_name
      self.name[2..-1]
    end
  end
end