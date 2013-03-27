require 'spec_helper'

describe SitePrism::Vcr::Fixtures do
  describe '#exchange' do
    def do_action
      fixtures.exchange([1, 3], [4, 5])
    end

    subject(:fixtures) { described_class.new([1, 2, 3]) }

    it 'should remove "1, 3" elements' do
      do_action

      fixtures.should_not include(1, 3)
    end

    it 'should add "4, 5" elements' do
      do_action

      fixtures.should include(4, 5)
    end
  end
end