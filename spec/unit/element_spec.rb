require 'spec_helper'

describe SPV::Element do
  let(:node)    { stub   }
  let(:parent)  { double }
  let(:applier) { double(apply: true) }

  before do
    SPV::Applier.stub(:new).and_return(applier)
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
      subject.stub(:apply_vcr)
      subject.stub( :click )
    end

    it 'call apply_vcr with click event in action_block' do
      expect(subject).to receive(:apply_vcr) do |action_block|
        expect(subject).to receive(:click)

        action_block.call
      end

      subject.click_and_apply_vcr
    end
  end

  describe '#apply_vcr' do
    subject { described_class.new(nil, parent) }
    let(:action_block) { proc { } }

    it 'applies custom fixtures' do
      expect(applier).to receive(:apply).with(
        kind_of(Proc)
      )

      subject.apply_vcr(action_block) {}
    end

    it 'runs action described in the proc' do
      applier.stub(:apply).and_yield

      expect(action_block).to receive(:call)

      subject.apply_vcr(action_block) {}
    end
  end
end
