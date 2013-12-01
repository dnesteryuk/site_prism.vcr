require 'spec_helper'

describe SPV::Fixtures::Manager do
  let(:options) { instance_double('SPV::Options', fixtures: ['some fixture']) }

  describe '#inject' do
    let(:fixture1) do
      instance_double(
        'SPV::Fixture',
        name: 'arya_stark',
        options: {erb: {testvar: true}}
      )
    end

    let(:fixture2) do
      instance_double(
        'SPV::Fixture',
        name: 'jon_snow',
        options: {}
      )
    end

    let(:fixtures) do
      [fixture1, fixture2]
    end

    subject(:manager) { described_class.new(options) }

    context 'when there are fixtures' do
      after do
        VCR.eject_cassette
        VCR.eject_cassette
      end

      it 'VCR holds the first fixture' do
        manager.inject(fixtures)

        VCR.eject_cassette
        fixture = VCR.eject_cassette

        expect(fixture.name).to eq('arya_stark')
        expect(fixture.erb).to eq({testvar: true})
      end

      it 'VCR holds the second fixture' do
        manager.inject(fixtures)

        fixture = VCR.eject_cassette

        expect(fixture.name).to eq('jon_snow')
        expect(fixture.erb).to be_nil
      end
    end

    context 'when there are not any fixtures' do
      it 'raises an error about no fixtures' do
        expect { manager.inject([]) }.to raise_error(
          ArgumentError,
          'No fixtures were specified to insert them into VCR'
        )
      end
    end
  end

  describe '#eject' do
    subject { described_class.new(options).eject }

    it 'ejects all fixtures from VCR' do
      expect(SPV::Helpers).to receive(:eject_all_cassettes)

      subject
    end
  end
end