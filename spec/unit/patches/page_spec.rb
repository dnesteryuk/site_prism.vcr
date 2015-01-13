require 'spec_helper'

describe SitePrism::Page do
  describe 'class methods' do
    describe '.adjust_parent_vcr_options' do
      subject { described_class.adjust_parent_vcr_options }

      context 'when there are not defined vcr options' do
        it 'raises an error' do
          expect{
            subject
          }.to raise_error(ArgumentError, 'There is not any Vcr options defined for the parent class')
        end
      end
    end

    describe '.new' do
      let(:applier) do
        instance_double(
          'SPV::Applier',
          alter_fixtures: true,
        )
      end

      before do
        allow(SPV::Applier).to receive(:new).and_return(applier)
      end

      it 'initializes the fixtures applier' do
        expect(SPV::Applier).to receive(:new).with(
          kind_of(described_class)
        )

        subject
      end

      context 'when there are defined the blocks to adjust Vcr options' do
        before do
          described_class.vcr_options_for_load { }
          described_class.adjust_parent_vcr_options {}
          described_class.adjust_parent_vcr_options {}
        end

        it 'alters Vcr fixtures' do
          expect(applier).to receive(:alter_fixtures).twice

          subject
        end
      end
    end
  end

  describe 'instance methods' do
    subject { SitePrism::Page.new }

    let(:applier) do
      instance_double(
        'SPV::Applier',
        apply_vcr: true,

      )
    end

    before do
      described_class.vcr_options_for_load { }
    end

    describe '#load_and_apply_vcr' do
      before do
        allow(subject).to receive(:load)
        allow(subject).to receive(:shift_event).and_yield.and_return(applier)
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
end