require 'spec_helper'

describe SPV::Options do
  let(:options) { described_class.new }

  describe '.new' do
    context 'when all allowed options are passed' do
      it 'holds the passed options' do
        waiter   = 'some'

        options = described_class.new(
          waiter: waiter
        )

        expect(options.waiter).to eq(waiter)
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
        expect(options.home_path).to eq('some/path/')
      end
    end

    context 'when the last symbol is not slash' do
      it 'returns the home path with a slash at the end of the path' do
        options.home_path = 'some/path'
        expect(options.home_path).to eq('some/path/')
      end
    end
  end

  describe '#dup_without_fixtures' do
    it 'returns a new instance of options' do
      cloned_options = options.dup_without_fixtures

      expect(cloned_options.object_id).to_not eq(options.object_id)
    end
  end
end