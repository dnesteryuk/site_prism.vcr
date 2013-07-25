module SPV
  class Waiter
    def initialize(node, fixtures_manager, options)
      @node, @waiter_method = node, options.waiter
      @fixtures_manager = fixtures_manager
      @options = options.waiter_options || {}
    end

    def wait
      if @waiter_method
        @node.instance_eval &@waiter_method

        if @options.fetch(:eject_cassettes, true)
          @fixtures_manager.eject
        end
      end
    end

    def with_new_options(options)
      self.class.new(@node, @fixtures_manager, options)
    end
  end
end