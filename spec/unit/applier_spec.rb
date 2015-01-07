require 'spec_helper'

describe SPV::Applier do
  shared_examples 'adjusting fixtures' do
    it 'initializes the fixtures adjuster with proper options' do
      expect(SPV::DSL::Adjuster).to receive(:new).with(
        proper_options,
        fixtures
      )

      do_action
    end

    it 'calls a given block within the context of the adjuster' do
      expect(adjuster).to receive(:fixtures)

      do_action
    end

    it 'receives the fixtures container' do
      expect(adjuster).to receive(:prepare_fixtures)

      do_action
    end
  end

  let(:node)             { double('node of DOM') }
  let(:options)          { instance_double('SPV::Options') }
  let(:fixtures)         { double('fixtures') }
  let(:initial_adjuster) do
    instance_double(
      'SPV::DSL::InitialAdjuster',
      prepare_fixtures: fixtures
    )
  end

  before do
    allow(SPV::Options).to receive(:new).and_return(options)
    allow(SPV::DSL::InitialAdjuster).to receive(:new).and_return(initial_adjuster)
  end

  before do
    allow(SPV::DSL::InitialAdjuster).to receive(:new).and_return(initial_adjuster)
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
        expect(initial_adjuster).to receive(:home_path)

        described_class.new(node) { home_path 'test' }
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
  end

  describe '#alter_fixtures' do
    let(:prepared_fixtures) { 'prepared_fixtures by adjuster' }

    let(:adjuster) do
      instance_double(
        'SPV::DSL::Adjuster',
        fixtures:         true,
        prepare_fixtures: prepared_fixtures
      )
    end

    let(:do_action) { applier.alter_fixtures { fixtures [] } }

    subject(:applier) { described_class.new(node) { } }

    before do
      allow(SPV::DSL::Adjuster).to receive(:new).and_return(adjuster)
    end

    it_behaves_like 'adjusting fixtures' do
      let(:proper_options) { options }
    end
  end

  describe '#apply_vcr' do
    let(:node)             { double('node of DOM', click: true) }
    let(:cloned_options)   { 'cloned options' }
    let(:options)          { instance_double('SPV::Options', clone_options: cloned_options) }

    let(:fixtures_manager) { instance_double('SPV::Fixtures::Manager', inject: true) }

    subject(:applier) { described_class.new(node) { } }

    context 'when an event is shifted' do
      before do
        allow(SPV::Fixtures::Manager).to receive(:inject).and_return(fixtures_manager)
        allow(SPV::Waiter).to receive(:wait)

        applier.shift_event { node.click }
      end

      context 'when the adjusting block is given' do
        let(:prepared_fixtures) { 'prepared_fixtures by adjuster' }

        let(:adjuster) do
          instance_double(
            'SPV::DSL::Adjuster',
            fixtures:         true,
            prepare_fixtures: prepared_fixtures
          )
        end

        let(:do_action) { applier.apply_vcr { fixtures [] } }

        before do
          allow(SPV::DSL::Adjuster).to receive(:new).and_return(adjuster)
        end

        it_behaves_like 'adjusting fixtures' do
          let(:proper_options) { cloned_options }
        end

        it 'applies the adjusted fixtures' do
          expect(SPV::Fixtures::Manager).to receive(:inject).with(
            prepared_fixtures,
            cloned_options
          )

          do_action
        end
      end

      context 'when the adjusting block is not given' do
        it 'does not initialize the fixture adjuster' do
          expect(SPV::DSL::Adjuster).to_not receive(:new)

          applier.apply_vcr
        end

        it 'applies the default fixtures' do
          expect(SPV::Fixtures::Manager).to receive(:inject).with(
            fixtures,
            cloned_options
          )

          applier.apply_vcr
        end
      end

      it 'does the click action over a node' do
        expect(node).to receive(:click)

        applier.apply_vcr
      end

      it 'waits until all HTTP interactions are finished' do
        expect(SPV::Waiter).to receive(:wait).with(
          node,
          fixtures_manager,
          cloned_options
        )

        applier.apply_vcr
      end
    end

    context 'when an event is not shifted' do
      it 'raises an error about no event' do
        expect{ subject.apply_vcr }.to raise_error(
          SPV::Applier::EventError,
          'Event is not shifted, before applying VCR you have to shift event with "shift_event" method'
        )
      end
    end
  end
end