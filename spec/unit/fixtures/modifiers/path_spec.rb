require 'spec_helper'

describe SPV::Fixtures::Modifiers::Path do
  describe '#modify' do
    let(:path)    { 'some path' }
    let(:options) { instance_double('SPV::OptionsWithPath', path: path) }
    let(:fixture) { instance_double('SPV::Fixture', shortcut_path: nil) }

    subject { described_class.new(options).modify(fixture) }

    context 'when the path does not end with slash symbol' do
      it 'adds a given path to the fixture with additional slash symbol' do
        expect(fixture).to receive(:prepend_path).with(path + '/')

        subject
      end
    end

    context 'when the path ends with slash symbol' do
      let(:path) { 'some path/' }

      it 'adds a given path to the fixture without additional slash symbol' do
        expect(fixture).to receive(:prepend_path).with(path)

        subject
      end
    end

    context 'when the fixture has a shortcut path' do
      let(:fixture) do
        instance_double(
          'SPV::Fixture',
          shortcut_path: 'myshortcut',
          clean_name:    'Max'
        )
      end

      it 'raises an error about a shortcut path' do
        expect{
          subject
        }.to raise_error(
          SPV::Fixtures::Modifiers::Path::HomePathError,
          "You cannot use a shortcut path while listing fixtures in the 'path' method. " <<
          "Please, use 'fixtures' method for 'Max' fixture or " <<
          "you can additionally use the 'path' method where you will specify a shortcut path as a path name." <<
          "Example: path(':myshortcut', ['Max'])"
        )
      end
    end
  end
end