require 'spec_helper'

class TestPage
  include SPV::Mixins::Page
end

describe SPV::Mixins::Page do
  describe 'class methods' do
    subject { TestPage }

    describe '.adjust_parent_vcr_options' do
      subject { TestPage.adjust_parent_vcr_options }

      context 'when there are not defined vcr options' do
        it 'raises an error' do
          expect{
            subject
          }.to raise_error(ArgumentError, 'There is not any Vcr options defined for the parent class')
        end
      end
    end
  end

  describe 'instance methods' do
    subject { TestPage.new }

    let(:applier) do
      instance_double(
        'SPV::Applier',
        apply_vcr:      true,
        alter_fixtures: true
      )
    end

    before do
      TestPage.vcr_options_for_load { }
    end

    describe '#load_and_apply_vcr' do
      before do
        allow(subject).to receive(:shift_event).and_return(applier)
        allow(subject).to receive(:load)
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

    describe '#shift_event' do
      before do
        allow(SPV::Applier).to receive(:new).and_return(applier)
        allow(applier).to receive(:shift_event).and_yield.and_return(applier)
      end

      context 'when the applier is not initialized yet' do
        it 'initializes the fixtures applier' do
          expect(SPV::Applier).to receive(:new).with(
            subject
          )

          subject.shift_event {}
        end

        context 'when there are the defined blocks to adjust Vcr options' do
          before do
            TestPage.vcr_options_for_load { }
            TestPage.adjust_parent_vcr_options {}
            TestPage.adjust_parent_vcr_options {}
          end

          it 'alters Vcr fixtures' do
            expect(applier).to receive(:alter_fixtures).twice

            subject.shift_event {}
          end
        end
      end

      context 'when the applier is already initialized' do
        it 'does not initialize it twice' do
          expect(SPV::Applier).to receive(:new).once

          subject.shift_event {}
          subject.shift_event {}
        end
      end

      it 'shifts an event to the applier' do
        expect(applier).to receive(:shift_event)

        subject.shift_event { }
      end
    end
  end
end