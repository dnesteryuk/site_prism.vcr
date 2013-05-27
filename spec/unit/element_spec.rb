require 'spec_helper'

describe SitePrism::Vcr::Element do
  let(:node)    { stub   }
  let(:parent)  { double }
  let(:options) { 'raw options' }
  let(:applier) { double(apply: true) }

  before do
    SitePrism::Vcr::Applier.stub(:new).and_return(applier)
  end

  describe '.new' do
    it 'initializes the fixtures applier' do
      SitePrism::Vcr::Applier.should_receive(:new).with(
        parent,
        options
      )

      b1 = proc { }

      described_class.new(nil, parent, options)
    end
  end

  describe '#click_and_apply_vcr' do
    subject { described_class.new(nil, parent, options) }

    before do
      subject.stub(:click)
    end

    it 'applies custom fixtures' do
      applier.should_receive(:apply).with(
        'custom fixtures',
        'some action',
        kind_of(Proc)
      )

      subject.click_and_apply_vcr(
        'custom fixtures',
        'some action'
      ) {}
    end

    it 'clicks on an element' do
      applier.stub(:apply).and_yield

      subject.should_receive(:click)

      subject.click_and_apply_vcr
    end
  end
end