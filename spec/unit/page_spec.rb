require 'spec_helper'

describe SitePrism::Page do
  subject { SitePrism::Page.new }

  describe '#apply_vcr' do
    let(:applier)      { double(apply: true) }
    let(:options)      { 'some options' }
    let(:action_block) { double(call: true) }

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

      subject.apply_vcr(action_block)
    end

    it 'applies fixtures' do
      applier.should_receive(:apply).with(
        kind_of(Proc)
      )

      subject.apply_vcr(action_block) { }
    end

    it 'does the action from the action block' do
      applier.stub(:apply).and_yield

      action_block.should_receive(:call)

      subject.apply_vcr('arg1', 'arg2', action_block) { }
    end
  end

  describe '#load_and_apply_vcr' do
    before do
      subject.stub(:apply_vcr)
      subject.stub(:load)
    end

    it 'applies vcr fixtures and loads the page' do
      expect(subject).to receive(:apply_vcr) do |action_block|
        expect(subject).to receive(:load).with('arg1', 'arg2')

        action_block.call
      end

      subject.load_and_apply_vcr('arg1', 'arg2') { }
    end
  end
end