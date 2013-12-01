require 'spec_helper'

describe SitePrism::Page do
  subject { SitePrism::Page.new }

  let(:applier) do
    instance_double(
      'SPV::Applier',
      apply_vcr: true
    )
  end

  before do
    SitePrism::Page.vcr_options_for_load { }
  end

  describe '.new' do
    before do
      SPV::Applier.stub(:new).and_return(applier)
    end

    it 'initializes the fixtures applier' do
      expect(SPV::Applier).to receive(:new).with(
        kind_of(described_class)
      )

      subject
    end
  end

  describe '#load_and_apply_vcr' do
    before do
      subject.stub(:load)
      subject.stub(:shift_event).and_yield.and_return(applier)
    end

    it 'shifts a load event to the applier' do
      expect(subject).to receive(:shift_event).and_yield.and_return(applier)
      expect(subject).to receive(:load).with('some arguments')

      subject.load_and_apply_vcr('some arguments')
    end

    it 'applies vcr' do
      expect(applier).to receive(:apply_vcr)

      subject.load_and_apply_vcr
    end
  end
end