require 'delegate'

module SPV
  class OptionsWithPath < SimpleDelegator
    attr_accessor :path
  end
end