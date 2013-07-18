module SPV
  module Helpers
    # Ejects all cassettes from Vcr.
    #
    # It can be useful when you don't define a waiter while describing
    # cassettes which will be applied on an action (click,
    # page loading actions or any other). If you don't define a waiter
    # this method should be used to avoid data mixing which can lead you to wrong
    # behavior in your acceptance tests.
    #
    # @return [void]
    # @api public
    def self.eject_all_cassettes
      while VCR.eject_cassette
      end
    end
  end
end