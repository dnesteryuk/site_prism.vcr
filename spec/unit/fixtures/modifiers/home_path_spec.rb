require 'spec_helper'

describe SPV::Fixtures::Modifiers::HomePath do
  describe '#modify' do
    let(:path)    { 'some home path' }
    let(:options) { double(home_path: path) }
    let(:fixture) { double(name: 'test_with_home_path', :has_link_to_home_path? => true) }

    subject { described_class.new(options).modify(fixture) }

    context 'when a name of the fixture has a link to the home path' do
      context 'when the home_path is defined' do
        it 'writes a proper path to the fixture' do
          expect(fixture).to receive(:set_home_path).with(path)

          subject
        end
      end

      context 'when the home_path is not defined' do
        before do
          options.stub(:home_path).and_return(nil)
        end

        it 'raises an argument error about wrong way of defining fixtures' do
          msg = 'You are trying to use a home path for test_with_home_path fixture. ' \
            'Home path cannot be used since it is not defined, please refer to the documentation ' \
            'to make sure you define the home path properly.'

          expect { subject }.to raise_error(
            ArgumentError, msg
          )
        end
      end
    end

    context 'when a name of the fixture has no link to the home path' do
      let(:fixture) { double(:has_link_to_home_path? => false) }

      it 'does not set any home path' do
        expect(fixture).to_not receive(:set_home_path)

        subject
      end
    end
  end
end