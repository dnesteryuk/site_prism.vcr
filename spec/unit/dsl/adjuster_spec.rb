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

    shared_examples 'when passed arguments are handled' do
      it 'handles old fixtures' do
        expect(fixtures_handler).to receive(:handle_raw).with(
          [*raw_old_fixtures],
          [home_path_modifier]
        )

        exchange
      end

      it 'handles new fixtures' do
        expect(fixtures_handler).to receive(:handle_raw).with(
          [*raw_new_fixtures],
          [home_path_modifier]
        )

        exchange
      end
    end

    let(:fixtures)           { double(exchange: true) }
    let(:fixtures_handler)   { double(handle_raw: true) }
    let(:home_path_modifier) { double(modify: true) }

    let(:raw_old_fixtures) { ['old fixtures'] }
    let(:raw_new_fixtures) { ['new fixtures'] }

    let(:old_fixture) { double }
    let(:new_fixture) { double }

    let(:handled_old_fixtures) { [old_fixture] }
    let(:handled_new_fixtures) { [new_fixture] }

    before do
      SPV::Fixtures::Handler.stub(:new).and_return(fixtures_handler)
      SPV::Fixtures::Modifiers::HomePath.stub(:new).and_return(home_path_modifier)

      fixtures_handler.stub(:handle_raw).and_return(
        handled_old_fixtures,
        handled_new_fixtures
      )
    end

    it 'initializes the home path modifier' do
      expect(SPV::Fixtures::Modifiers::HomePath).to receive(:new).with(options)

      exchange
    end

    context 'when strings are passed as arguments' do
      let(:old_fixtures) { 'old fixtures' }
      let(:new_fixtures) { 'new fixtures' }

      it_behaves_like 'when passed arguments are handled'
    end

    context 'when arrays are passed as arguments' do
      it_behaves_like 'when passed arguments are handled'
    end

    it 'exchanges fixtures' do
      expect(fixtures).to receive(:exchange).with(
        handled_old_fixtures, handled_new_fixtures
      )

      exchange
    end
  end
end