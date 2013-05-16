require 'spec_helper'

describe SitePrism::Vcr::Element do
  let(:options)          { double(fixtures: 'some prepared fixtures') }
  let(:fixtures_manager) { double(inject: true) }
  let(:fixtures)         { double }
  let(:node)             { stub   }
  let(:parent)           { double }
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
    subject { described_class.new(node, parent, raw_options) }

    it 'initializes the options handler' do
      SitePrism::Vcr::Options.should_receive(:new).with(raw_options)

      subject
    end

    it 'initializes the initial adjuster' do
      SitePrism::Vcr::InitialAdjuster.should_receive(:new).with(
        options
      )

      described_class.new(node, parent, raw_options)
    end

    context 'when a block is given' do
      it 'calls a given block within the context of the adjuster' do
        initial_adjuster.should_receive(:mymeth)

        described_class.new(node, parent, raw_options) { mymeth }
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

  describe '#click_and_apply_vcr' do
    let(:node)              { double(click: true) }
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

    subject(:element) { described_class.new(node, parent, options) }

    before do
      SitePrism::Vcr::Adjuster.stub(:new).and_return(adjuster)
      SitePrism::Vcr::Waiter.stub(:new).and_return(waiter)
    end

    it 'initializes the fixtures adjuster with a new instance of options' do
      SitePrism::Vcr::Adjuster.should_receive(:new).with(
        cloned_options,
        fixtures
      )

      element.click_and_apply_vcr
    end

    context 'when a block is defined' do
      it 'calls a given block within the context of the adjuster' do
        adjuster.should_receive(:mymeth)

        element.click_and_apply_vcr { mymeth }
      end
    end

    context 'when a block is not defined' do
      def apply_custom_fixtures
        element.click_and_apply_vcr(['some custom fixture'], :replace)
      end

      it 'defines custom fixtures for the adjuster' do
        adjuster.should_receive(:fixtures).with(
          ['some custom fixture']
        )

        apply_custom_fixtures
      end

      it 'replaces default fixtures with given fixtures' do
        adjuster.should_receive(:replace)

        apply_custom_fixtures
      end
    end

    it 'applies fixtures' do
      fixtures_manager.should_receive(:inject).with(prepared_fixtures)

      element.click_and_apply_vcr
    end

    it 'initializes the waiter' do
      SitePrism::Vcr::Waiter.should_receive(:new).with(
        parent,
        fixtures_manager,
        cloned_options
      ).and_return(waiter)

      element.click_and_apply_vcr
    end

    it 'should do the click action' do
      element.should_receive(:click)

      element.click_and_apply_vcr
    end

    it 'should wait until all HTTP interactions are finished' do
      waiter.should_receive(:wait)

      element.click_and_apply_vcr
    end
  end
end