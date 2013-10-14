require 'spec_helper'

describe SPV::Fixtures::Converter do
  describe '.convert_raw' do
    let(:first_fixture)  { 'test_fixture' }
    let(:second_fixture) { {fixture: 'fixture_name', options: 'vcr options'} }

    subject {
      described_class.convert_raw(
        [first_fixture, second_fixture]
      )
    }

    before do
      SPV::Fixture.stub(:new).and_return('first prepared', 'second prepared')
    end

    it 'initializes first object of Fixture class' do
      expect(SPV::Fixture).to receive(:new).with(first_fixture)

      subject
    end

    it 'initializes second object of Fixture class' do
      expect(SPV::Fixture).to receive(:new).with(
        second_fixture[:fixture], second_fixture[:options]
      )

      subject
    end

    it 'returns a prepared list of fixtures' do
      expect(subject).to eq(['first prepared', 'second prepared'])
    end
  end
end