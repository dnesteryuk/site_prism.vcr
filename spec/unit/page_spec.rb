require 'spec_helper'

describe SitePrism::Page do
  describe '#load_and_apply_vcr' do
    let(:applier)  { double(apply: true) }
    let(:options)  { 'some options' }

    subject { SitePrism::Page.new }

    before do
      SitePrism::Page.vcr_options_for_load(
        options
      )

      SitePrism::Vcr::Applier.stub(:new).and_return(applier)
    end

    it 'initializes the fixtures applier' do
      SitePrism::Vcr::Applier.should_receive(:new).with(
        subject,
        options
      ).and_return(applier)

      subject.load_and_apply_vcr
    end

    it 'applies fixtures' do
      applier.should_receive(:apply).with(
        [],
        nil,
        kind_of(Proc)
      )

      subject.load_and_apply_vcr() { }
    end

    it 'loads the page' do
      applier.stub(:apply).and_yield

      subject.should_receive(:load).with('arg1', 'arg2')

      subject.load_and_apply_vcr('arg1', 'arg2') { }
    end
  end
end