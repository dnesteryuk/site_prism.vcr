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
      expect(SitePrism::Vcr::Applier).to receive(:new).with(
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
      expect(applier).to receive(:apply).with(
        kind_of(Proc)
      )

      subject.click_and_apply_vcr() {}
    end

    it 'clicks on an element' do
      applier.stub(:apply).and_yield

      expect(subject).to receive(:click)

      subject.click_and_apply_vcr
    end
  end
end