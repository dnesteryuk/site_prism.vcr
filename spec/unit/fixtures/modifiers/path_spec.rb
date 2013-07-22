require 'spec_helper'

describe SPV::Fixtures::Modifiers::Path do
  describe '#modify' do
    let(:path)    { 'some path' }
    let(:options) { double(path: path) }
    let(:fixture) { double }

    subject { described_class.new(options).modify(fixture) }

    context 'when the path does not end with slash symbol' do
      it 'adds a given path to the fixture with additional slash symbol' do
        expect(fixture).to receive(:add_path).with(path + '/')

        subject
      end
    end

    context 'when the path ends with slash symbol' do
      let(:path)  { 'some path/' }

      it 'add a given path to the fixture without additional slash symbol' do
        expect(fixture).to receive(:add_path).with(path)

        subject
      end
    end
  end
end