require 'spec_helper'

describe SitePrism::Vcr::FixturesHandler do
  let(:options)          { double(fixtures: ['default fixtures']) }
  let(:fixtures_handler) { described_class.new(options) }

  describe '#fixtures' do
    let(:options) do
      double(
        home_path: 'fixtures/path/',
        fixtures:  ['~/test', '~/custom/test', 'custom/test']
      )
    end

    context 'when the home_path is defined' do
      it 'returns fixtures with a right path' do
        expect(fixtures_handler.fixtures).to eq([
          'fixtures/path/test',
          'fixtures/path/custom/test',
          'custom/test'
        ])
      end
    end

    context 'when the home_path is not defined' do
      before do
        options.stub(:home_path).and_return(nil)
      end

      it 'raises an argument error about wrong way of defining fixtures' do
        msg = 'You are trying to use a home path for these: ~/test, ~/custom/test fixtures. ' \
          'They cannot be used since the home_path is not defined, please refer to the documentation ' \
          'to make sure you define the home path properly.'

        expect { fixtures_handler.fixtures }.to raise_error(
          ArgumentError, msg
        )
      end
    end

    context 'when raw fixtures are passed' do
      it 'returns prepared fixtures' do
        raw_fixtures = ['some raw']

        expect(fixtures_handler.fixtures(raw_fixtures)).to eq(raw_fixtures)
      end
    end
  end

  describe '#add_fixtures' do
    it 'adds new fixtures' do
      fixtures_handler.add_fixtures(['new fixture'])
      expect(fixtures_handler.fixtures).to eq(['default fixtures', 'new fixture'])
    end
  end
end