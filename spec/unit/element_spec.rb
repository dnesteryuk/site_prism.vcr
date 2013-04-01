require 'spec_helper'

describe SitePrism::Vcr::Element do
  let(:fixtures_handler) { double(apply: true) }

  before do
    SitePrism::Vcr::FixturesHandler.stub(:new).and_return(fixtures_handler)
  end

  describe '#new' do
    it 'should initialize the fixtures handler' do
      SitePrism::Vcr::FixturesHandler.should_receive(:new).with(
        ['some fixtures']
      ).and_return(fixtures_handler)

      described_class.new(stub, fixtures: ['some fixtures'])
    end
  end

  describe '#click_and_apply_vcr' do
    let(:base) { double(click: true) }
    let(:node) { double(origin_synchronize: true, base: base) }

    subject(:element) { described_class.new(node) }

    before do
      node.stub(:origin_synchronize).and_yield
    end

    context 'when custom fixtures are not given' do
      it 'should apply fixtures' do
        fixtures_handler.should_receive(:apply).with([], :union)

        element.click_and_apply_vcr
      end
    end

    context 'when custom fixtures are given' do
      it 'should apply custom fixtures' do
        fixtures_handler.should_receive(:apply).with(
          ['some custom fixture'], :union
        )

        element.click_and_apply_vcr(['some custom fixture'])
      end
    end

    context 'when custom fixtures are requested to replace default fixtures' do
      it 'should apply custom fixtures' do
        fixtures_handler.should_receive(:apply).with(
          ['some custom fixture'], :replace
        )

        element.click_and_apply_vcr(['some custom fixture'], :replace)
      end
    end

    it 'should synhronize the click action' do
      node.should_receive(:origin_synchronize)

      element.click_and_apply_vcr
    end

    it 'should do the click action' do
      base.should_receive(:click)

      element.click_and_apply_vcr
    end
  end
end