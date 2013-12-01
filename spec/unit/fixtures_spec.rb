require 'spec_helper'

describe SPV::Fixtures do
  let(:fixture1) { instance_double('SPV::Fixture', name: 'fixture1') }
  let(:fixture2) { instance_double('SPV::Fixture', name: 'fixture2') }
  let(:fixture3) { instance_double('SPV::Fixture', name: 'fixture3') }
  let(:fixture4) { instance_double('SPV::Fixture', name: 'fixture4') }
  let(:fixture5) { instance_double('SPV::Fixture', name: 'fixture5') }

  subject(:fixtures) { described_class.new([fixture1, fixture2, fixture3]) }

  describe '#exchange' do
    def exchange
      fixtures.exchange([fixture1, fixture3], [fixture4, fixture5])
    end

    it 'removes "fixture1" and "fixture3" elements' do
      new_fixtures = exchange

      expect(new_fixtures).to_not include(fixture1, fixture3)
    end

    it 'adds "fixture4, fixture5" elements' do
      new_fixtures = exchange

      expect(new_fixtures).to include(fixture4, fixture5)
    end

    it 'does not touch the original object' do
      exchange

      expect(fixtures).to include(fixture1, fixture2, fixture3)
    end
  end

  describe '#replace' do
    context 'when fixtures are passed' do
      it 'does not change the original object' do
        fixtures.replace([fixture4, fixture5])

        expect(fixtures).to include(fixture1, fixture2, fixture3)
        expect(fixtures).to_not include(fixture4, fixture5)
      end

      it 'returns a new container with fixtures' do
        new_fixtures = fixtures.replace([fixture4, fixture5])

        expect(new_fixtures).to include(fixture4, fixture5)
        expect(new_fixtures).to_not include(fixture1, fixture2, fixture3)
      end
    end

    context 'when no fixtures are passed' do
      it 'returns itself' do
        new_fixtures = fixtures.replace([])

        expect(new_fixtures).to eq(fixtures)
      end
    end
  end

  describe '#union' do
    it 'does not change the original object' do
      fixtures.union([fixture4, fixture5])

      expect(fixtures).to include(fixture1, fixture2, fixture3)
      expect(fixtures).to_not include(fixture4, fixture5)
    end

    it 'returns a new container with fixtures' do
      new_fixtures = fixtures.union([fixture4, fixture5])

      expect(new_fixtures).to include(fixture1, fixture2, fixture3, fixture4, fixture5)
    end
  end
end