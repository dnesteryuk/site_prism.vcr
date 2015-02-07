module SPV
  # Keeps options which are used to identify path to fixtures
  # and options for a waiter which holds execution until expectation
  # has been met.
  class Options
    attr_accessor :waiter, :waiter_options, :shortcut_paths

    def initialize(options = {})
      @shortcut_paths = {}

      options.each do |key, val|
        public_send("#{key}=", val)
      end
    end

    # Defines shortcut path to fixtures.
    #
    # @param shortcut [String]
    # @param path [String] Path to fixtures.
    #
    # @return [void]
    #
    # @api private
    def add_shortcut_path(shortcut, path)
      path << '/' unless path[-1, 1] == '/'

      self.shortcut_paths[shortcut] = path
    end

    # Returns a full path associated with a shortcut.
    #
    # @param shortcut [String]
    #
    # @return [String]
    #
    # @api private
    def shortcut_path(shortcut)
      self.shortcut_paths[shortcut]
    end

    # Returns a copy of itself.
    #
    # @return [SPV::Options]
    #
    # @api private
    def clone_options
      dup
    end

    # Returns options of a waiter in a hash format.
    # If no options are defined, returns an empty hash.
    #
    # @return [Hash]
    #
    # @api private
    def waiter_options
      @waiter_options || {}
    end

    # Merges already defined waiter's options with a given hash.
    #
    # If waiter's options are not defined yet, it will define waiter options
    # with a given hash.
    #
    # @return [void]
    #
    # @api private
    def merge_waiter_options!(options)
      self.waiter_options = self.waiter_options.merge(options)
    end
  end # class Options
end # module SPV