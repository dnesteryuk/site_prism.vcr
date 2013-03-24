require 'spec_helper'

describe SitePrism::Vcr::Element do
  describe '#click_and_apply_fixtures' do
    let(:base) { double(click: true) }
    let(:node) { double(origin_synchronize: true, base: base) }

    subject(:element) { SitePrism::Vcr::Element.new(node, fixtures: ['test1', 'test2']) }

    before do
      VCR.stub(:insert_cassette)

      node.stub(:origin_synchronize).and_yield
    end

    context 'when fixtures are defined through options' do
      it 'should apply the first fixture' do
        VCR.should_receive(:insert_cassette).with('test1')

        element.click_and_apply_fixtures
      end

      it 'should apply the second fixture' do
        VCR.should_receive(:insert_cassette).with('test2')

        element.click_and_apply_fixtures
      end
    end

    context 'when custom fixtures are passed into the method' do
      it 'should apply the first custom fixture' do
        VCR.should_receive(:insert_cassette).with('custom1')

        element.click_and_apply_fixtures(['custom1', 'custom2'])
      end

      it 'should apply the second custom fixture' do
        VCR.should_receive(:insert_cassette).with('custom2')

        element.click_and_apply_fixtures(['custom1', 'custom2'])
      end
    end

    it 'should synhronize the click action' do
      node.should_receive(:origin_synchronize)

      element.click_and_apply_fixtures
    end

    it 'should do the click action' do
      base.should_receive(:click)

      element.click_and_apply_fixtures
    end
  end
end