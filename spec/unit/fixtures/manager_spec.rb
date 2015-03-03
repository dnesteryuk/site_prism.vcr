require 'spec_helper'

describe SPV::Fixtures::Manager do
  let(:options) { instance_double('SPV::Options') }

  let(:fixture1) do
    instance_double(
      'SPV::Fixture',
      name: 'arya_stark',
      options: {
        erb: {
          testvar: true,
          port:    123
        }
      }
    )
  end

  let(:fixture2) do
    instance_double(
      'SPV::Fixture',
      name: 'jon_snow',
      options: {}
    )
  end

  let(:fixtures) do
    [fixture1, fixture2]
  end

  describe '.inject' do
    let(:manager) { instance_double('SPV::Fixtures::Manager', inject: true) }

    subject { described_class.inject(fixtures, options) }

    before do
      allow(described_class).to receive(:new).and_return(manager)
    end

    it 'initializes a new instance of the fixtures manager class' do
      expect(described_class).to receive(:new).with(fixtures, options)

      subject
    end

    it 'injects fixtures' do
      expect(manager).to receive(:inject)

      subject
    end

    it 'returns an instance of the manager' do
      res = subject

      expect(manager).to eq(res)
    end
  end

  describe '#inject' do
    subject(:manager) { described_class.new(fixtures, options) }

    context 'when there are fixtures' do
      after do
        VCR.eject_cassette
        VCR.eject_cassette
      end

      context 'when VCR holds the first fixture' do
        before do
          manager.inject

          VCR.eject_cassette
          @fixture = VCR.eject_cassette
        end

        it 'has a right fixture name' do
          expect(@fixture.name).to eq('arya_stark')
        end

        it 'has custom erb variables' do
          expect(@fixture.erb).to eq(testvar: true, port: 123)
        end
      end

      context 'when VCR holds the second fixture' do
        before do
          manager.inject

          @fixture = VCR.eject_cassette
        end

        it 'has a right fixture name' do
          expect(@fixture.name).to eq('jon_snow')
        end

        it 'has no custom erb variables which was defined for the first fixture' do
          expect(@fixture.erb).to_not eq(testvar: true, port: 123)
        end
      end
    end

    context 'when there are not any fixtures' do
      let(:fixtures) { [] }

      it 'raises an error about no fixtures' do
        expect { manager.inject }.to raise_error(
          ArgumentError,
          'No fixtures were specified to insert them into VCR'
        )
      end
    end

    context 'when an extra option is passed' do
      let(:fixture) do
        instance_double(
          'SPV::Fixture',
          name: 'jon_snow',
          options: {
            eject: false
          }
        )
      end

      let(:fixtures) { [fixture] }

      it 'does not break Vcr' do
        expect { manager.inject }.not_to raise_error
      end
    end
  end

  describe '#eject' do
    subject(:manager) { described_class.new(fixtures, options) }

    before do
      manager.inject
    end

    it 'ejects the inserted fixtures' do
      manager.eject

      expect(VCR.eject_cassette).to equal(nil)
    end

    context 'when there are fixtures inserted by another code' do
      before do
        VCR.insert_cassette('test_cassette')
      end

      it 'does not remove fixtures which are not inserted by this instance of the fixtures manager' do
        manager.eject

        expect(VCR.eject_cassette.name).to eq('test_cassette')
        expect(VCR.eject_cassette).to equal(nil)
      end
    end

    context 'when there are fixtures which are protected from ejecting' do
      let(:fixture2) do
        instance_double(
          'SPV::Fixture',
          name: 'jon_snow',
          options: {
            eject: false
          }
        )
      end

      let(:fixtures) { [fixture1, fixture2] }

      it 'does not remove the protected fixture' do
        manager.eject

        expect(VCR.eject_cassette.name).to eq('jon_snow')
        expect(VCR.eject_cassette).to equal(nil)
      end
    end
  end
end