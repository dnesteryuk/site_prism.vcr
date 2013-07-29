require 'spec_helper'

describe SPV::Fixtures::Handler do
  let(:options)            { double }
  let(:converted_fixtures) { [] }
  let(:fixtures_converter) { double(convert_raw: converted_fixtures) }

  subject { described_class.new(options) }

  before do
    SPV::Fixtures::Converter.stub(:new).and_return(fixtures_converter)
  end

  describe '.new' do
    it 'initializes the fixtures handler' do
      expect(SPV::Fixtures::Converter).to receive(:new)

      subject
    end
  end

  describe '#handle_raw' do
    def handle_raw
      subject.handle_raw(raw_fixtures, [modifier])
    end

    let(:raw_fixtures)       { 'some raw fixtures' }
    let(:converted_fixture)  { 'converted fixture' }
    let(:converted_fixtures) { [converted_fixture] }
    let(:modifier)           { double(modify: true) }

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
end