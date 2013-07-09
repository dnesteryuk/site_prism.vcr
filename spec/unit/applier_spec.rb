require 'spec_helper'

describe SitePrism::Vcr::Applier do
  let(:node)             { double }
  let(:options)          { double(fixtures: 'some prepared fixtures') }
  let(:fixtures_manager) { double(inject: true) }
  let(:fixtures)         { double }
  let(:initial_adjuster) { double(prepared_fixtures: fixtures) }

  before do
    SitePrism::Vcr::Options.stub(:new).and_return(options)
    SitePrism::Vcr::InitialAdjuster.stub(:new).and_return(initial_adjuster)

    SitePrism::Vcr::FixturesManager.stub(:new).and_return(fixtures_manager)
  end

  before do
    SitePrism::Vcr::InitialAdjuster.stub(:new).and_return(initial_adjuster)
  end

  describe '.new' do
    let(:raw_options) { 'some options' }
    subject { described_class.new(node, raw_options) }

    it 'initializes the options object' do
      SitePrism::Vcr::Options.should_receive(:new).with(raw_options)

      subject
    end

    it 'initializes the initial adjuster' do
      SitePrism::Vcr::InitialAdjuster.should_receive(:new).with(
        options
      )

      subject
    end

    context 'when a block is given' do
      it 'calls a given block within the context of the adjuster' do
        initial_adjuster.should_receive(:mymeth)

        described_class.new(node, raw_options) { mymeth }
      end
    end

    it 'receives the fixtures container' do
      initial_adjuster.should_receive(:prepared_fixtures)

      subject
    end

    it 'initializes the fixtures manager' do
      SitePrism::Vcr::FixturesManager.should_receive(:new).with(
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

    subject(:applier) { described_class.new(node, 'raw options') }

    before do
      SitePrism::Vcr::Adjuster.stub(:new).and_return(adjuster)
      SitePrism::Vcr::Waiter.stub(:new).and_return(waiter)
    end

    it 'initializes the fixtures adjuster with a new instance of options' do
      SitePrism::Vcr::Adjuster.should_receive(:new).with(
        cloned_options,
        fixtures
      )

      applier.apply { }
    end

    it 'calls a given block within the context of the adjuster' do
      adjuster.should_receive(:mymeth)

      applier.apply(proc{ mymeth }) {}
    end

    it 'applies fixtures' do
      fixtures_manager.should_receive(:inject).with(prepared_fixtures)

      applier.apply { }
    end

    it 'initializes the waiter' do
      SitePrism::Vcr::Waiter.should_receive(:new).with(
        node,
        fixtures_manager,
        cloned_options
      ).and_return(waiter)

      applier.apply { }
    end

    it 'does the click action over a node' do
      node.should_receive(:click)

      applier.apply do
        node.click
      end
    end

    it 'waits until all HTTP interactions are finished' do
      waiter.should_receive(:wait)

      applier.apply { }
    end
  end
end