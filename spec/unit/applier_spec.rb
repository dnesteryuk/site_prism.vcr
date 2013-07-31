require 'spec_helper'

describe SPV::Applier do
  let(:node)             { double }
  let(:options)          { double(fixtures: 'some prepared fixtures') }
  let(:fixtures_manager) { double(inject: true) }
  let(:fixtures)         { double }
  let(:initial_adjuster) { double(prepared_fixtures: fixtures) }

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
      expect(initial_adjuster).to receive(:prepared_fixtures)

      subject
    end

    it 'initializes the fixtures manager' do
      expect(SPV::Fixtures::Manager).to receive(:new).with(
        options
      ).and_return(fixtures_manager)

      subject
    end
  end

  describe '#apply' do
    let(:cloned_options)    { 'cloned options' }
    let(:options)           { double(dup_without_fixtures: cloned_options, fixtures: false) }
    let(:waiter)            { double(wait: true) }
    let(:prepared_fixtures) { 'prepared_fixtures by adjuster' }

    let(:adjuster) do
      double(
        mymeth:            true,
        fixtures:          true,
        replace:           true,
        prepared_fixtures: prepared_fixtures
      )
    end

    subject(:applier) { described_class.new(node) { } }

    before do
      SPV::DSL::Adjuster.stub(:new).and_return(adjuster)
      SPV::Waiter.stub(:new).and_return(waiter)
    end

    it 'initializes the fixtures adjuster with a new instance of options' do
      expect(SPV::DSL::Adjuster).to receive(:new).with(
        cloned_options,
        fixtures
      )

      applier.apply { }
    end

    it 'calls a given block within the context of the adjuster' do
      expect(adjuster).to receive(:mymeth)

      applier.apply(proc{ mymeth }) {}
    end

    it 'applies fixtures' do
      expect(fixtures_manager).to receive(:inject).with(prepared_fixtures)

      applier.apply { }
    end

    it 'initializes the waiter' do
      expect(SPV::Waiter).to receive(:new).with(
        node,
        fixtures_manager,
        cloned_options
      ).and_return(waiter)

      applier.apply { }
    end

    it 'does the click action over a node' do
      expect(node).to receive(:click)

      applier.apply do
        node.click
      end
    end

    it 'waits until all HTTP interactions are finished' do
      expect(waiter).to receive(:wait)

      applier.apply { }
    end
  end
end