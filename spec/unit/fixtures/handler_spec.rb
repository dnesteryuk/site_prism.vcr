require 'spec_helper'

describe SPV::Fixtures::Handler do
  let(:options)            { instance_double('SPV::Options') }
  let(:converted_fixtures) { [] }
  let(:fixtures_converter) { SPV::Fixtures::Converter }

  subject { described_class.new(options) }

  before do
    allow(SPV::Fixtures::Converter).to receive(:convert_raw).and_return(converted_fixtures)
  end

  describe '#handle_raw' do
    def handle_raw
      subject.handle_raw(raw_fixtures, [modifier])
    end

    let(:raw_fixtures)       { 'some raw fixtures' }
    let(:converted_fixture)  { 'converted fixture' }
    let(:converted_fixtures) { [converted_fixture] }
    let(:modifier)           do
      instance_double(
        'SPV::Fixtures::Modifiers::HomePath',
        modify: true
      )
    end

    it 'converts raw fixtures' do
      expect(fixtures_converter).to receive(:convert_raw).with(raw_fixtures)

      handle_raw
    end

    it 'modifies the converted fixtures' do
      expect(modifier).to receive(:modify).with(converted_fixture)

      handle_raw
    end

    it 'returns handled fixtures' do
      expect(handle_raw).to eq(converted_fixtures)
    end
  end

  describe '#handle_set_raws' do
    def handle_set_raws
      subject.handle_set_raws(raw_fixtures_1, raw_fixtures_2, modifiers)
    end

    let(:raw_fixtures_1)     { 'raw fixtures #1' }
    let(:raw_fixtures_2)     { 'raw fixtures #2' }
    let(:handled_fixtures_1) { 'handled fixtures #1' }
    let(:handled_fixtures_2) { 'handled fixtures #2' }
    let(:modifiers)          { 'some modifiers' }

    before do
      allow(subject).to receive(:handle_raw).and_return(handled_fixtures_1, handled_fixtures_2)
    end

    it 'handles the first set of raw fixtures' do
      expect(subject).to receive(:handle_raw).with(raw_fixtures_1, modifiers)

      handle_set_raws
    end

    it 'handles the second set of raw fixtures' do
      expect(subject).to receive(:handle_raw).with(raw_fixtures_2, modifiers)

      handle_set_raws
    end

    it 'returns all handled fixtures' do
      expect(handle_set_raws).to eq([handled_fixtures_1, handled_fixtures_2])
    end
  end
end