require 'spec_helper'

describe SPV::Adjuster do
  let(:raw_fixtures)     { 'some fixtures' }
  let(:fixtures)         { double }
  let(:fixtures_handler) { double(fixtures: raw_fixtures, clean_fixtures: true) }
  let(:options)          { double(waiter: :wait_for_me) }

  before do
    SPV::FixturesHandler.stub(:new).and_return(fixtures_handler)
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
      expect(fixtures_handler).to receive(:clean_fixtures)

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
      expect(fixtures_handler).to receive(:clean_fixtures)

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
        old_fixtures,
        new_fixtures
      )
    end

    shared_examples 'when passed arguments are prepared' do
      it 'prepares old fixtures' do
        expect(fixtures_handler).to receive(:fixtures).with([*old_fixtures])

        exchange
      end

      it 'prepares new fixtures' do
        expect(fixtures_handler).to receive(:fixtures).with([*new_fixtures])

        exchange
      end
    end

    let(:fixtures)     { double(exchange: true) }
    let(:old_fixtures) { ['old fixtures'] }
    let(:new_fixtures) { ['new fixtures'] }

    let(:prepared_old_fixtures) { 'prepared old fixtures' }
    let(:prepared_new_fixtures) { 'prepared new fixtures' }

    before do
      fixtures_handler.stub(:fixtures).and_return(
        prepared_old_fixtures,
        prepared_new_fixtures
      )
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