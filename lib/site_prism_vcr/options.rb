module SPV
  # Keeps options which are used to identify path to cassettes
  # and options for a waiter which holds execution until expectation
  # has been met.
  class Options
    attr_accessor :waiter, :waiter_options, :home_path

    def initialize(options = {})
      options.each do |key, val|
        public_send("#{key}=", val)
      end
    end

    # Defines path to cassettes.
    #
    # @param val [String] Path to cassettes.
    #
    # @return [void]
    #
    # @api private
    def home_path=(val)
      val << '/' unless val[-1, 1] == '/'

      @home_path = val
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
  end
end