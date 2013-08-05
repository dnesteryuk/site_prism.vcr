require 'spec_helper'

describe SPV::Options do
  let(:options) { described_class.new }

  describe '.new' do
    it 'holds the passed options' do
      waiter = 'some'

      options = described_class.new(
        waiter: waiter
      )

      expect(options.waiter).to eq(waiter)
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

  describe '#clone_options' do
    it 'returns a new instance of options' do
      cloned_options = options.clone_options

      expect(cloned_options.object_id).to_not eq(options.object_id)
    end
  end
end