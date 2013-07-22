require 'spec_helper'

describe SPV::FixturesHandler do
  let(:options)          { double }
  let(:fixtures_handler) { described_class.new(options) }

  describe '#fixtures' do
    let(:options) do
      double(
        home_path: 'fixtures/path/'
      )
    end

    let(:fixture1) {
      double(
        name:                      'test_with_home_path',
        set_home_path:             true,
        :has_link_to_home_path? => true
      )
    }

    let(:fixture2) {
      double(name: 'test_without_home_path', :has_link_to_home_path? => false)
    }

    subject { fixtures_handler.fixtures }

    before do
      fixtures_handler.add_fixtures([fixture1, fixture2])
    end

    context 'when the home_path is defined' do

      it 'writes a proper path for first fixture' do
        expect(fixture1).to receive(:set_home_path).with('fixtures/path/')

        subject
      end

      it 'does not change second fixture' do
        expect(fixture2).to_not receive(:set_home_path)

        subject
      end
    end

    context 'when the home_path is not defined' do
      before do
        options.stub(:home_path).and_return(nil)
      end

      it 'raises an argument error about wrong way of defining fixtures' do
        msg = 'You are trying to use a home path for these: test_with_home_path fixtures. ' \
          'They cannot be used since the home_path is not defined, please refer to the documentation ' \
          'to make sure you define the home path properly.'

        expect { subject }.to raise_error(
          ArgumentError, msg
        )
      end
    end

    context 'when raw fixtures are passed' do
      subject { fixtures_handler.fixtures([fixture1]) }

      it 'writes a proper path for the fixture' do
        expect(fixture1).to receive(:set_home_path).with('fixtures/path/')

        subject
      end
    end
  end
end