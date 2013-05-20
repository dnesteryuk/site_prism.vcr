require 'spec_helper'

describe SitePrism::Vcr::Fixtures do
  subject(:fixtures) { described_class.new([1, 2, 3]) }

  describe '#exchange' do
    def exchange
      fixtures.exchange([1, 3], [4, 5])
    end

    it 'removes "1, 3" elements' do
      new_fixtures = exchange

      new_fixtures.should_not include(1, 3)
    end

    it 'adds "4, 5" elements' do
      new_fixtures = exchange

      new_fixtures.should include(4, 5)
    end

    it 'does not touch the original object' do
      exchange

      fixtures.should include(1, 2, 3)
    end
  end

  describe '#replace' do
    context 'when cassettes are passed' do
      it 'does not change an original object' do
        fixtures.replace([4, 5])

        fixtures.should include(1, 2, 3)
        fixtures.should_not include(4, 5)
      end

      it 'returns a new set with fixtures' do
        new_fixtures = fixtures.replace([4, 5])

        new_fixtures.should include(4, 5)
        new_fixtures.should_not include(1, 2, 3)
      end
    end

    context 'when no cassettes are passed' do
      it 'returns itself' do
        new_fixtures = fixtures.replace([])

        new_fixtures.should eq(fixtures)
      end
    end
  end
end