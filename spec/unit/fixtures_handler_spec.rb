require 'spec_helper'

describe SitePrism::Vcr::FixturesHandler do
  let(:options) { double(fixtures: ['some fixture']) }

  describe '#inject' do
    let(:cassettes)   { ['some'] }
    let(:fixtures)    { ['fixture1', 'fixture2'] }
    subject(:handler) { described_class.new(options) }

    before do
      VCR.stub(:insert_cassette)
    end

    context 'when there are fixtures' do
      context 'inserting fixtures to VCR' do
        it 'inserts the first fixture to VCR' do
          VCR.should_receive(:insert_cassette).with('fixture1')

          handler.inject(fixtures)
        end

        it 'inserts the second fixture to VCR' do
          VCR.should_receive(:insert_cassette).with('fixture2')

          handler.inject(fixtures)
        end
      end
    end

    context 'when there are not any fixtures' do
      it 'raises an error about no fixtures' do
        expect { handler.inject([]) }.to raise_error(
          ArgumentError,
          'No fixtures were specified to insert them into VCR'
        )
      end
    end
  end

  describe '#eject' do
    subject { described_class.new(options).eject }

    before do
      VCR.stub(:eject_cassette).and_return(1, 2, 3, false)
    end

    it 'ejects all fixtures from VCR' do
      VCR.should_receive(:eject_cassette).exactly(4).times

      subject
    end
  end
end