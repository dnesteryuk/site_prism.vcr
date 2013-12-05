require 'spec_helper'

describe SPV::Options do
  subject(:options) { described_class.new }

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

  describe '#waiter_options' do
    context 'when options are not defined' do
      it 'returns an empty hash' do
        expect(options.waiter_options).to be_a(Hash)
      end
    end

    context 'when options are defined' do
      it 'returns it' do
        expected = {eject_fixtures: false}

        subject.waiter_options = expected

        expect(subject.waiter_options).to eq(expected)
      end
    end
  end

  describe '#merge_waiter_options!' do
    it 'redefines default options' do
      subject.waiter_options = {
        eject_fixtures:      false,
        some_another_option: true
      }

      subject.merge_waiter_options!(eject_fixtures: true)

      expect(options.waiter_options).to include(
        eject_fixtures:      true,
        some_another_option: true
      )
    end
  end
end