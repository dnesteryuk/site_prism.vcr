require 'spec_helper'

describe SitePrism::Vcr::Fixtures do
  subject(:fixtures) { described_class.new([1, 2, 3]) }

  describe '#exchange' do
    def exchange
      fixtures.exchange([1, 3], [4, 5])
    end

    it 'removes "1, 3" elements' do
      new_fixtures = exchange

      expect(new_fixtures).to_not include(1, 3)
    end

    it 'adds "4, 5" elements' do
      new_fixtures = exchange

      expect(new_fixtures).to include(4, 5)
    end

    it 'does not touch the original object' do
      exchange

      expect(fixtures).to include(1, 2, 3)
    end
  end

  describe '#replace' do
    context 'when cassettes are passed' do
      it 'does not change an original object' do
        fixtures.replace([4, 5])

        expect(fixtures).to include(1, 2, 3)
        expect(fixtures).to_not include(4, 5)
      end

      it 'returns a new set with fixtures' do
        new_fixtures = fixtures.replace([4, 5])

        expect(new_fixtures).to include(4, 5)
        expect(new_fixtures).to_not include(1, 2, 3)
      end
    end

    context 'when no cassettes are passed' do
      it 'returns itself' do
        new_fixtures = fixtures.replace([])

        expect(new_fixtures).to eq(fixtures)
      end
    end
  end
end