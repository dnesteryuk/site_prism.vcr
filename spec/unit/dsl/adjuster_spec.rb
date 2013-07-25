require 'spec_helper'

describe SPV::DSL::Adjuster do
  let(:raw_fixtures)     { 'some fixtures' }
  let(:fixtures)         { double }
  let(:tmp_keeper)       { double(fixtures: raw_fixtures, clean_fixtures: true) }
  let(:options)          { double(waiter: :wait_for_me) }

  before do
    SPV::Fixtures::TmpKeeper.stub(:new).and_return(tmp_keeper)
  end

  subject { described_class.new(options, fixtures) }

  describe '#replace' do
    let(:replaced_fixtures) { 'replaced fixtures' }

    before do
      fixtures.stub(:replace).and_return(replaced_fixtures)
    end

    it 'replaces fixtures' do
      expect(fixtures).to receive(:replace).with(raw_fixtures)

      subject.replace
    end

    it 'cleans fixtures being kept in the fixtures handler' do
      expect(tmp_keeper).to receive(:clean_fixtures)

      subject.replace
    end

    it 'returns a new container with fixtures' do
      subject.replace

      expect(subject.prepared_fixtures).to eq(replaced_fixtures)
    end
  end

  describe '#union' do
    let(:new_fixtures) { 'new fixtures' }

    before do
      fixtures.stub(:union).and_return(new_fixtures)
    end

    it 'replaces fixtures' do
      expect(fixtures).to receive(:union).with(raw_fixtures)

      subject.union
    end

    it 'cleans fixtures being kept in the fixtures handler' do
      expect(tmp_keeper).to receive(:clean_fixtures)

      subject.union
    end

    it 'returns a new container with fixtures' do
      subject.union

      expect(subject.prepared_fixtures).to eq(new_fixtures)
    end
  end

  describe '#exchange' do
    def exchange
      subject.exchange(
        raw_old_fixtures,
        raw_new_fixtures
      )
    end

    shared_examples 'when passed arguments are prepared' do
      it 'converts old fixtures' do
        expect(fixtures_converter).to receive(:convert_raw).with([*raw_old_fixtures])

        exchange
      end

      it 'sets a home path for old fixture' do
        expect(home_path_modifier).to receive(:modify).with(old_fixture)

        exchange
      end

      it 'prepares new fixtures' do
        expect(fixtures_converter).to receive(:convert_raw).with([*raw_new_fixtures])

        exchange
      end

      it 'sets a home path for old fixture' do
        expect(home_path_modifier).to receive(:modify).with(new_fixture)

        exchange
      end
    end

    let(:fixtures)           { double(exchange: true) }
    let(:fixtures_converter) { double(convert_raw: true) }
    let(:home_path_modifier) { double(modify: true) }

    let(:raw_old_fixtures) { ['old fixtures'] }
    let(:raw_new_fixtures) { ['new fixtures'] }

    let(:old_fixture) { double }
    let(:new_fixture) { double }

    let(:prepared_old_fixtures) { [old_fixture] }
    let(:prepared_new_fixtures) { [new_fixture] }

    before do
      SPV::Fixtures::Converter.stub(:new).and_return(fixtures_converter)
      SPV::Fixtures::Modifiers::HomePath.stub(:new).and_return(home_path_modifier)

      fixtures_converter.stub(:convert_raw).and_return(
        prepared_old_fixtures,
        prepared_new_fixtures
      )
    end

    it 'initializes the home path modifier' do
      expect(SPV::Fixtures::Modifiers::HomePath).to receive(:new).with(options)

      exchange
    end

    context 'when strings are passed as arguments' do
      let(:old_fixtures) { 'old fixtures' }
      let(:new_fixtures) { 'new fixtures' }

      it_behaves_like 'when passed arguments are prepared'
    end

    context 'when arrays are passed as arguments' do
      it_behaves_like 'when passed arguments are prepared'
    end

    it 'exchanges fixtures' do
      expect(fixtures).to receive(:exchange).with(
        prepared_old_fixtures, prepared_new_fixtures
      )

      exchange
    end
  end
end