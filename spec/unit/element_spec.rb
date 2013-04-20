require 'spec_helper'

describe SitePrism::Vcr::Element do
  let(:fixtures_handler) { double(apply: true) }
  let(:node)   { stub }
  let(:parent) { double }

  before do
    SitePrism::Vcr::FixturesHandler.stub(:new).and_return(fixtures_handler)
  end

  describe '#new' do
    let(:options) { 'some options' }

    it 'should initialize the fixtures handler' do
      SitePrism::Vcr::FixturesHandler.should_receive(:new).with(
        options
      ).and_return(fixtures_handler)

      described_class.new(node, parent, options)
    end
  end

  describe '#click_and_apply_vcr' do
    let(:node)        { double(click: true) }
    subject(:element) { described_class.new(node, parent) }

    it 'should apply fixtures' do
      fixtures_handler.should_receive(:apply).with(
        ['some custom fixture'], :replace
      )

      element.click_and_apply_vcr(['some custom fixture'], :replace)
    end

    it 'should do the click action' do
      element.should_receive(:click)

      element.click_and_apply_vcr
    end

    context 'when a waiter is defined' do
      let(:parent)      { double(wait_for_me: true) }
      subject(:element) { described_class.new(node, parent, waiter: :wait_for_me) }

      it 'should call waiter to wait untill all AJAX requests are finished' do
        parent.should_receive(:wait_for_me)

        element.click_and_apply_vcr
      end
    end
  end
end