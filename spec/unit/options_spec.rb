require 'spec_helper'

describe SitePrism::Vcr::Options do
  let(:options) { described_class.new }

  describe '.new' do
    context 'when all allowed options are passed' do
      it 'holds the passed options' do
        waiter   = 'some'
        fixtures = ['some fixtures']

        options = described_class.new(
          waiter:       waiter,
          'fixtures' => fixtures
        )

        options.waiter.should eq(waiter)
        options.fixtures.should eq(fixtures)
      end
    end

    context 'when no allowed option is passed' do
      it 'raises an error' do
        expect {
          described_class.new(
            myopt:  true,
            waiter: 'some waiter'
          )
        }.to raise_error(
          ArgumentError,
          "'myopt' is not known option for handling Vcr fixtures"
        )
      end
    end

    context 'when a few no allowed options are passed' do
      it 'raises an error' do
        expect {
          described_class.new(
            myopt:      true,
            test_opt:   false,
            'waiter' => 'some waiter'
          )
        }.to raise_error(
          ArgumentError,
          "'myopt', 'test_opt' are not known options for handling Vcr fixtures"
        )
      end
    end
  end

  describe '#home_path=' do
    context 'when the last symbol is a slash' do
      it 'returns the home path as it is' do
        options.home_path = 'some/path/'
        options.home_path.should eq('some/path/')
      end
    end

    context 'when the last symbol is not slash' do
      it 'returns the home path with a slash at the end of the path' do
        options.home_path = 'some/path'
        options.home_path.should eq('some/path/')
      end
    end
  end

  describe '#fixtures' do
    before do
      options.fixtures = ['~/test', '~/custom/test', 'custom/test']
    end

    context 'when the home_path is defined' do
      before do
        options.home_path = 'fixtures/path'
      end

      it 'returns fixtures with a right path' do
        options.fixtures.should eq([
          'fixtures/path/test',
          'fixtures/path/custom/test',
          'custom/test'
        ])
      end
    end

    context 'when the home_path is not defined' do
      it 'raises an argument error about wrong way of defining fixtures' do
        expect { options.fixtures }.to raise_error(
          ArgumentError, 'You are trying to use a home path for these: ~/test, ~/custom/test fixtures. They cannot be used since the home_path is not defined, please refer to the documentation to make sure you define the home path properly.'
        )
      end
    end
  end
end