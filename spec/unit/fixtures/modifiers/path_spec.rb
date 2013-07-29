require 'spec_helper'

describe SPV::Fixtures::Modifiers::Path do
  describe '#modify' do
    let(:path)    { 'some path' }
    let(:options) { double(path: path) }
    let(:fixture) { double(:has_link_to_home_path? => false) }

    subject { described_class.new(options).modify(fixture) }

    context 'when the path does not end with slash symbol' do
      it 'adds a given path to the fixture with additional slash symbol' do
        expect(fixture).to receive(:add_path).with(path + '/')

        subject
      end
    end

    context 'when the path ends with slash symbol' do
      let(:path) { 'some path/' }

      it 'adds a given path to the fixture without additional slash symbol' do
        expect(fixture).to receive(:add_path).with(path)

        subject
      end
    end

    context 'when the fixture has a link to the home path' do
      let(:fixture) { double(:has_link_to_home_path? => true, clean_name: 'Max') }

      it 'raises an error about link to the home path' do
        expect{
          subject
        }.to raise_error(
          SPV::Fixtures::Modifiers::Path::HomePathError,
          "You cannot use the home path while listing fixtures in the 'path' method. " <<
          "Please, use 'fixtures' method for 'Max' fixture or " <<
          "you can additionally use the 'path' method where you will specify a home path as a path name." <<
          "Example: path('~/', ['Max'])"
        )
      end
    end
  end
end