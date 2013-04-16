require 'spec_helper'

describe SitePrism::Vcr::Fixtures do
  subject(:fixtures) { described_class.new([1, 2, 3]) }

  describe '#exchange' do
    def do_action
      fixtures.exchange([1, 3], [4, 5])
    end

    it 'should remove "1, 3" elements' do
      do_action

      fixtures.should_not include(1, 3)
    end

    it 'should add "4, 5" elements' do
      do_action

      fixtures.should include(4, 5)
    end
  end

  describe '#replace' do
    it 'should not change an original object' do
      fixtures.replace([4, 5])

      fixtures.should include(1, 2, 3)
      fixtures.should_not include(4, 5)
    end

    it 'should return a new set with fixtures' do
      new_fixtures = fixtures.replace([4, 5])

      new_fixtures.should include(4, 5)
      new_fixtures.should_not include(1, 2, 3)
    end
  end
end