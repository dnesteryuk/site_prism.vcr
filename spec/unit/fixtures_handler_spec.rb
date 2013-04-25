require 'spec_helper'

describe SitePrism::Vcr::FixturesHandler do
  describe '.new' do
    it 'should initialize the fixtures container with given cassettes' do
      SitePrism::Vcr::Fixtures.should_receive(:new).with(['some fixture'])

      described_class.new(
        fixtures: ['some fixture']
      )
    end
  end

  describe '#apply' do
    let(:cassettes)   { ['some'] }
    let(:fixtures)    { double(map: [], size: 2, replace: cassettes) }
    subject(:handler) { described_class.new }

    before do
      SitePrism::Vcr::Fixtures.stub(:new).and_return(fixtures)
      VCR.stub(:insert_cassette)
    end

    context 'when custom fixtures are passed' do
      context 'when a behavior is not specified' do
        it 'should replace default fixtures with custom fixtures' do
          fixtures.should_receive(:replace).with(['my custom']).and_return(cassettes)

          handler.apply(['my custom'])
        end
      end

      context 'when behavior is specified' do
        it 'should union default fixtures with custom fixtures' do
          fixtures.should_receive(:union).with(['my custom']).and_return(cassettes)

          handler.apply(['my custom'], :union)
        end
      end

      context 'when a fixture is a defined as a string' do
        it 'should turn it into array' do
          fixtures.should_receive(:replace).with(['my string']).and_return(cassettes)

          handler.apply('my string')
        end
      end
    end

    context 'when no custom fixtures passed' do
      it 'should not add custom fixtures' do
        fixtures.should_receive(:replace).with([]).and_return(cassettes)

        handler.apply
      end
    end

    context 'when there are fixtures' do
      context 'inseting fixtures to VCR' do
        before do
          fixtures.stub(:replace).and_return(['fixture1', 'fixture2'])
          VCR.stub(:insert_cassette)
        end

        it 'should insert the first fixture to VCR' do
          VCR.should_receive(:insert_cassette).with('fixture1')

          handler.apply
        end

        it 'should insert the second fixture to VCR' do
          VCR.should_receive(:insert_cassette).with('fixture2')

          handler.apply
        end
      end
    end

    context 'when there are not any fixtures' do
      before do
        fixtures.stub(:replace).and_return([])
      end

      it 'should raise an error' do
        expect { handler.apply }.to raise_error(
          ArgumentError,
          'No fixtures were specified to insert them into VCR'
        )
      end
    end
  end
end