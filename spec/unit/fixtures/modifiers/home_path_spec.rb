require 'spec_helper'

describe SPV::Fixtures::Modifiers::HomePath do
  describe '#modify' do
    let(:path)          { 'some home path' }
    let(:shortcut_path) { 'some shortcut' }
    let(:options)       { instance_double('SPV::Options') }
    let(:fixture) do
      instance_double(
        'SPV::Fixture',
        name:          'test_with_home_path',
        shortcut_path: shortcut_path
      )
    end

    subject { described_class.new(options).modify(fixture) }

    context 'when a name of the fixture has a shortcut path' do
      context 'when a given shortcut path is defined' do
        it 'writes a proper path to the fixture' do
          expect(options).to receive(:shortcut_path).with(shortcut_path).and_return(path)
          expect(fixture).to receive(:set_home_path).with(path)

          subject
        end
      end

      context 'when a given shortcut path is not defined' do
        before do
          allow(options).to receive(:shortcut_path).and_return(nil)
        end

        it 'raises an argument error about wrong way of defining fixtures' do
          msg = "You are trying to use the 'some shortcut' shortcut path " \
            "for test_with_home_path fixture. This shortcut path cannot be " \
            "used since it is not defined, please refer to the documentation to make " \
            "sure you properly define the shortcut path."

          expect { subject }.to raise_error(
            ArgumentError, msg
          )
        end
      end
    end

    context 'when a name of the fixture has not a shortcut path' do
      let(:fixture) do
        instance_double(
          'SPV::Fixture',
          shortcut_path: nil
        )
      end

      it 'does not set any home path' do
        expect(fixture).to_not receive(:set_home_path)

        subject
      end
    end
  end
end