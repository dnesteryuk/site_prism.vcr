require 'spec_helper'

describe SitePrism::Vcr::Element do
  let(:fixtures_handler) { double(apply: true) }
  let(:waiter)           { double(wait: true) }
  let(:node)             { stub }
  let(:parent)           { double }

  before do
    SitePrism::Vcr::FixturesHandler.stub(:new).and_return(fixtures_handler)
    SitePrism::Vcr::Waiter.stub(:new).and_return(waiter)
  end

  describe '#new' do
    let(:options) { 'some options' }
    subject { described_class.new(node, parent, options) }

    it 'should initialize the fixtures handler' do
      SitePrism::Vcr::FixturesHandler.should_receive(:new).with(
        options
      ).and_return(fixtures_handler)

      subject
    end

    it 'should initialize the waiter' do
      SitePrism::Vcr::Waiter.should_receive(:new).with(
        parent,
        options
      ).and_return(waiter)

      subject
    end
  end

  describe '#click_and_apply_vcr' do
    let(:node)        { double(click: true) }
    let(:options)     { 'some options' }
    subject(:element) { described_class.new(node, parent, options) }

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

      it 'should initialize the fixtures adjuster' do
        SitePrism::Vcr::Adjuster.should_receive(:new).with(
          fixtures_handler,
          options
        )

        element.click_and_apply_vcr { }
      end

      it 'should call a given block within fixtures adjuster context' do
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
      it 'should apply fixtures' do
        fixtures_handler.should_receive(:apply).with(
          ['some custom fixture'], :replace
        )

        element.click_and_apply_vcr(['some custom fixture'], :replace)
      end

      it 'should initialize the fixtures adjuster' do
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