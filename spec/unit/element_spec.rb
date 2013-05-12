require 'spec_helper'

describe SitePrism::Vcr::Element do
  let(:options)          { double }
  let(:fixtures_handler) { double(apply: true) }
  let(:waiter)           { double(wait: true) }
  let(:node)             { stub }
  let(:parent)           { double }

  before do
    SitePrism::Vcr::Options.stub(:new).and_return(options)
    SitePrism::Vcr::FixturesHandler.stub(:new).and_return(fixtures_handler)
    SitePrism::Vcr::Waiter.stub(:new).and_return(waiter)
  end

  describe '#new' do
    let(:raw_options) { 'some options' }
    subject { described_class.new(node, parent, raw_options) }

    it 'initializes the options handler' do
      SitePrism::Vcr::Options.should_receive(:new).with(raw_options)

      subject
    end

    context 'when a block is passed' do
      let(:adjuster) { double }

      before do
        SitePrism::Vcr::InitialAdjuster.stub(:new).and_return(adjuster)
      end

      it 'initializes the initial adjuster' do
        SitePrism::Vcr::InitialAdjuster.should_receive(:new).with(
          options
        )

        described_class.new(node, parent, raw_options) {}
      end

      it 'calls a given block within fixtures adjuster context' do
        adjuster.should_receive(:mymeth)

        described_class.new(node, parent, raw_options) { mymeth }
      end
    end

    it 'initializes the fixtures handler' do
      SitePrism::Vcr::FixturesHandler.should_receive(:new).with(
        options
      ).and_return(fixtures_handler)

      subject
    end
  end

  describe '#click_and_apply_vcr' do
    let(:node)           { double(click: true) }
    let(:cloned_options) { 'cloned options' }
    let(:options)        { double(dup_without_fixtures: cloned_options) }

    let(:adjuster) do
      double(
        mymeth:          true,
        replace:         true,
        fixtures:        true,
        modify_fixtures: true
      )
    end

    subject(:element) { described_class.new(node, parent, options) }

    before do
      SitePrism::Vcr::Adjuster.stub(:new).and_return(adjuster)
    end

    it 'initializes the fixtures adjuster with a new instance of options' do
      SitePrism::Vcr::Adjuster.should_receive(:new).with(
        cloned_options,
        fixtures_handler
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

      it 'defines the action for the adjuster' do
        adjuster.should_receive(:replace)

        apply_custom_fixtures
      end
    end

    it 'applies fixtures' do
      adjuster.should_receive(:modify_fixtures)

      element.click_and_apply_vcr
    end

    it 'initializes the waiter' do
      SitePrism::Vcr::Waiter.should_receive(:new).with(
        parent,
        cloned_options
      ).and_return(waiter)

      element.click_and_apply_vcr
    end

    it 'should do the click action' do
      element.should_receive(:click)

      element.click_and_apply_vcr
    end

    it 'should wait until AJAX requests finish' do
      waiter.should_receive(:wait)

      element.click_and_apply_vcr
    end
  end
end