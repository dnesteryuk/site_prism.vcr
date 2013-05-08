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

    it 'initializes the waiter' do
      SitePrism::Vcr::Waiter.should_receive(:new).with(
        parent,
        options
      ).and_return(waiter)

      subject
    end
  end

  describe '#click_and_apply_vcr' do
    let(:node)           { double(click: true) }
    let(:cloned_options) { 'cloned options' }
    let(:options)        { double(dup_without_fixtures: cloned_options) }
    subject(:element)    { described_class.new(node, parent, options) }

    context 'when a block is defined' do
      let(:fixtures_adjuster) do
        double(
          mymeth:          true,
          modify_fixtures: true,
          waiter:          :wait_for_items
        )
      end

      before do
        SitePrism::Vcr::Adjuster.stub(:new).and_return(fixtures_adjuster)
        waiter.stub(:waiter=)
      end

      it 'initializes the fixtures adjuster with a new instance of options' do
        SitePrism::Vcr::Adjuster.should_receive(:new).with(
          cloned_options,
          fixtures_handler
        )

        element.click_and_apply_vcr { }
      end

      it 'calls a given block within fixtures adjuster context' do
        fixtures_adjuster.should_receive(:mymeth)

        element.click_and_apply_vcr { mymeth }
      end

      it 'should define a new waiter method' do
        waiter.should_receive(:waiter=).with(:wait_for_items)

        element.click_and_apply_vcr { }
      end

      it 'should modify fixtures' do
        fixtures_adjuster.should_receive(:modify_fixtures)
        element.click_and_apply_vcr { }
      end

      it 'should not touch the fixtures handler' do
        fixtures_handler.should_not_receive(:apply)

        element.click_and_apply_vcr { }
      end
    end

    context 'when a block is not defined' do
      it 'applies fixtures' do
        fixtures_handler.should_receive(:apply).with(
          ['some custom fixture'], :replace
        )

        element.click_and_apply_vcr(['some custom fixture'], :replace)
      end

      it 'the fixtures adjuster is not initialized' do
        SitePrism::Vcr::Adjuster.should_not_receive(:new)

        element.click_and_apply_vcr(['some custom fixture'])
      end
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