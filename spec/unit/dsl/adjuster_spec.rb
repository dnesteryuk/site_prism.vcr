require 'spec_helper'

describe SPV::DSL::Adjuster do
  let(:raw_fixtures) { 'some fixtures' }
  let(:fixtures)     { instance_double('SPV::Fixtures', exchange: true) }
  let(:tmp_keeper)   {
    instance_double(
      'SPV::Fixtures::TmpKeeper',
      {fixtures: raw_fixtures, clean_fixtures: true}
    )
  }

  let(:options) {
    instance_double(
      'SPV::Options',
      waiter:                :wait_for_me,
      merge_waiter_options!: nil
    )
  }

  before do
    SPV::Fixtures::TmpKeeper.stub(:new).and_return(tmp_keeper)
  end

  subject { described_class.new(options, fixtures) }

  describe '#prepare_fixtures' do
    context 'when the replace action is defined' do
      let(:replaced_fixtures) { 'replaced fixtures' }

      before do
        fixtures.stub(:replace).and_return(replaced_fixtures)

        subject.replace
      end

      it 'replaces fixtures' do
        expect(fixtures).to receive(:replace).with(raw_fixtures)

        subject.prepare_fixtures
      end

      it 'cleans fixtures being kept in the fixtures handler' do
        expect(tmp_keeper).to receive(:clean_fixtures)

        subject.prepare_fixtures
      end

      it 'returns a new container with fixtures' do
        expect(subject.prepare_fixtures).to eq(replaced_fixtures)
      end
    end

    describe 'when the union action is defined' do
      let(:new_fixtures) { 'new fixtures' }

      before do
        fixtures.stub(:union).and_return(new_fixtures)
        subject.union
      end

      it 'joins fixtures' do
        expect(fixtures).to receive(:union).with(raw_fixtures)

        subject.prepare_fixtures
      end

      it 'cleans fixtures being kept in the fixtures handler' do
        expect(tmp_keeper).to receive(:clean_fixtures)

        subject.prepare_fixtures
      end

      it 'returns a new container with fixtures' do
        expect(subject.prepare_fixtures).to eq(new_fixtures)
      end
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
      it 'handles raw fixtures' do
        expect(fixtures_handler).to receive(:handle_set_raws).with(
          expected_raw_old_fixtures,
          expected_raw_new_fixtures,
          [home_path_modifier]
        )

        exchange
      end
    end

    let(:fixtures_handler)   { instance_double('SPV::Fixtures::Handler') }
    let(:home_path_modifier) { double('home path modifier') }

    let(:raw_old_fixtures) { ['old fixtures'] }
    let(:raw_new_fixtures) { ['new fixtures'] }

    let(:expected_raw_old_fixtures) { raw_old_fixtures }
    let(:expected_raw_new_fixtures) { raw_new_fixtures }

    let(:handled_old_fixtures) { ['old fixture'] }
    let(:handled_new_fixtures) { ['old fixture'] }

    before do
      SPV::Fixtures::Handler.stub(:new).and_return(fixtures_handler)
      SPV::Fixtures::Modifiers::HomePath.stub(:new).and_return(home_path_modifier)

      fixtures_handler.stub(:handle_set_raws).and_return([
        handled_old_fixtures,
        handled_new_fixtures
      ])
    end

    it 'initializes the home path modifier' do
      expect(SPV::Fixtures::Modifiers::HomePath).to receive(:new).with(options)

      exchange
    end

    context 'when no arrays are passed as arguments' do
      let(:raw_old_fixtures) { {old_fixtures: 'hash with vcr options'} }
      let(:raw_new_fixtures) { {new_fixtures: 'hash with vcr options'} }

      let(:expected_raw_old_fixtures) { [raw_old_fixtures] }
      let(:expected_raw_new_fixtures) { [raw_new_fixtures] }

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

  describe '#waiter_options' do
    it 'merges default waiter options with a given' do
      expect(options).to receive(:merge_waiter_options!).with(my: 'options')

      subject.waiter_options(my: 'options')
    end
  end
end