require 'spec_helper'

describe SPV::Element do
  let(:node)    { double('node of DOM') }
  let(:parent)  { double('parent element') }
  let(:applier) { instance_double('SPV::Applier', apply_vcr: true) }

  before do
    allow(SPV::Applier).to receive(:new).and_return(applier)
  end

  describe '.new' do
    it 'initializes the fixtures applier' do
      expect(SPV::Applier).to receive(:new).with(
        parent
      )

      b1 = proc { }

      described_class.new(nil, parent)
    end
  end

  describe '#click_and_apply_vcr' do
    subject { described_class.new(nil, parent) }

    before do
      allow(subject).to receive(:click)
      allow(subject).to receive(:shift_event).and_yield.and_return(applier)
    end

    it 'shifts a click event to the applier' do
      expect(subject).to receive(:shift_event).and_yield.and_return(applier)
      expect(subject).to receive(:click)

      subject.click_and_apply_vcr
    end

    it 'applies vcr' do
      expect(applier).to receive(:apply_vcr)

      subject.click_and_apply_vcr
    end
  end
end
