require 'spec_helper'

describe SPV::Applier do
  let(:node)             { double('node of DOM') }
  let(:options)          { instance_double('SPV::Options') }
  let(:fixtures_manager) { instance_double('SPV::Fixtures::Manager', inject: true) }
  let(:fixtures)         { double('fixtures') }
  let(:initial_adjuster) do
    instance_double(
      'SPV::DSL::InitialAdjuster',
      prepare_fixtures: fixtures
    )
  end

  before do
    SPV::Options.stub(:new).and_return(options)
    SPV::DSL::InitialAdjuster.stub(:new).and_return(initial_adjuster)

    SPV::Fixtures::Manager.stub(:new).and_return(fixtures_manager)
  end

  before do
    SPV::DSL::InitialAdjuster.stub(:new).and_return(initial_adjuster)
  end

  describe '.new' do
    subject { described_class.new(node) { } }

    it 'initializes the options object' do
      expect(SPV::Options).to receive(:new)

      subject
    end

    it 'initializes the initial adjuster' do
      expect(SPV::DSL::InitialAdjuster).to receive(:new).with(
        options
      )

      subject
    end

    context 'when a block is given' do
      it 'calls a given block within the context of the adjuster' do
        expect(initial_adjuster).to receive(:mymeth)

        described_class.new(node) { mymeth }
      end
    end

    context 'when a block is not given' do
      it 'does not get an error' do
        described_class.new(node)
      end
    end

    it 'receives the fixtures container' do
      expect(initial_adjuster).to receive(:prepare_fixtures)

      subject
    end

    it 'initializes the fixtures manager' do
      expect(SPV::Fixtures::Manager).to receive(:new).with(
        options
      ).and_return(fixtures_manager)

      subject
    end
  end

  describe '#apply_vcr' do
    let(:node)        { double('node of DOM', click: true) }
    subject(:applier) { described_class.new(node) { } }

    context 'when an event is shifted' do
      let(:cloned_options)    { 'cloned options' }
      let(:options)           { instance_double('SPV::Options', clone_options: cloned_options) }
      let(:waiter)            { instance_double('SPV::Waiter', wait: true) }
      let(:prepared_fixtures) { 'prepared_fixtures by adjuster' }

      let(:adjuster) do
        instance_double(
          'DSL::Adjuster',
          fixtures:         true,
          prepare_fixtures: prepared_fixtures
        )
      end

      before do
        SPV::DSL::Adjuster.stub(:new).and_return(adjuster)
        SPV::Waiter.stub(:new).and_return(waiter)

        applier.shift_event { node.click }
      end

      it 'initializes the fixtures adjuster with a new instance of options' do
        expect(SPV::DSL::Adjuster).to receive(:new).with(
          cloned_options,
          fixtures
        )

        applier.apply_vcr
      end

      context 'when a block is given' do
        it 'calls a given block within the context of the adjuster' do
          expect(adjuster).to receive(:fixtures)

          applier.apply_vcr { fixtures }
        end
      end

      it 'applies fixtures' do
        expect(fixtures_manager).to receive(:inject).with(prepared_fixtures)

        applier.apply_vcr
      end

      it 'initializes the waiter' do
        expect(SPV::Waiter).to receive(:new).with(
          node,
          fixtures_manager,
          cloned_options
        ).and_return(waiter)

        applier.apply_vcr
      end

      it 'does the click action over a node' do
        expect(node).to receive(:click)

        applier.apply_vcr
      end

      it 'waits until all HTTP interactions are finished' do
        expect(waiter).to receive(:wait)

        applier.apply_vcr
      end
    end

    context 'when an event is not shifted' do
      it 'raises an error about no event' do
        expect{ subject.apply_vcr }.to raise_error(
          SPV::Applier::EventError,
          'Event is not shifted, before applying Vcr you have to shift event with "shift_event" method'
        )
      end
    end
  end
end