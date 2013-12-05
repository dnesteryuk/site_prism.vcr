module SPV
  class Options
    attr_accessor :waiter, :waiter_options, :home_path

    def initialize(options = {})
      options.each do |key, val|
        public_send("#{key}=", val)
      end
    end

    def home_path=(val)
      val << '/' unless val[-1, 1] == '/'

      @home_path = val
    end

    def clone_options
      dup
    end

    def waiter_options
      @waiter_options || {}
    end

    # Merges already defined waiter's options with a given hash.
    #
    # If waiter's options are not defined yet, it will define waiter options
    # with a given hash.
    def merge_waiter_options!(options)
      self.waiter_options = self.waiter_options.merge(options)
    end
  end
end