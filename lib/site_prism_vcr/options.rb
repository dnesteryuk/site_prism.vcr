# TODO: should be this class immutable?
module SPV
  class Options
    attr_accessor :waiter, :waiter_options, :home_path

    def initialize(options = {})
      check_options options # TODO: since we have strict API for defining fixtures, this check we don't need any more

      options.each do |key, val|
        public_send("#{key}=", val)
      end
    end

    def home_path=(val)
      val << '/' unless val[-1, 1] == '/'

      @home_path = val
    end

    # TODO: remove this method
    def dup_without_fixtures
      dup
    end

    protected
      def check_options(options)
        keys = options.keys.map(&:to_sym) - [:waiter]

        if keys.size > 0
          if keys.size == 1
            part, opt_end = 'is', ''
          else
            part, opt_end = 'are', 's'
          end

          keys.map!{|key| "'#{key}'" }

          msg = "#{keys.join(', ')} #{part} not known option#{opt_end} for handling Vcr fixtures"

          raise ArgumentError.new(msg)
        end
      end
  end
end