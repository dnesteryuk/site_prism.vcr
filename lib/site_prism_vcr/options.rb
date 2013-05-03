module SitePrism
  module Vcr
    class Options
      attr_accessor :fixtures, :waiter

      def initialize(options = {})
        check_options options

        options.each do |key, val|
          public_send("#{key}=", val)
        end
      end

      protected
        def check_options(options)
          keys = options.keys.map(&:to_sym) - [:fixtures, :waiter]

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
end