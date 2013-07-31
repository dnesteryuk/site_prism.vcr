require 'spec_helper'

describe SPV::Fixtures::Manager do
  let(:options) { double(fixtures: ['some fixture']) }

  describe '#inject' do
    let(:fixture1)    { double(name: 'arya_stark', options: {erb: {testvar: true}}) }
    let(:fixture2)    { double(name: 'jon_snow', options: {}) }

    let(:fixtures)    { [fixture1, fixture2] }
    subject(:manager) { described_class.new(options) }

    context 'when there are fixtures' do
      context 'inserting fixtures to VCR' do
        it 'inserts the first fixture to VCR' do
          manager.inject(fixtures)

          VCR.eject_cassette
          fixture = VCR.eject_cassette

          expect(fixture.name).to eq('arya_stark')
          expect(fixture.erb).to eq({testvar: true})
        end

        it 'inserts the second fixture to VCR' do
          manager.inject(fixtures)

          fixture = VCR.eject_cassette

          expect(fixture.name).to eq('jon_snow')
          expect(fixture.erb).to be_nil
        end
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