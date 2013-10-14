# TODO: should be this class immutable?
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
  end
end