require 'spec_helper'

describe SPV::Waiter do
  let(:node)    { double('node of DOM') }
  let(:options) {
    instance_double(
      'SPV::Options',
      waiter_options: nil,
      waiter: nil
    )
  }

  let(:fixtures_manager) {
    instance_double(
      'SPV::Fixtures::Manager',
      eject: true
    )
  }

  subject(:waiter)       { described_class.new(node, fixtures_manager, options) }

  describe '#wait' do
    context 'when a waiter is defined' do
      let(:node) { double('node of DOM', wait_for_content: true) }

      before do
        options.stub(:waiter).and_return(proc { self.wait_for_content })
      end

      it 'calls the waiter to wait until all HTTP interactions are finished' do
        expect(node).to receive(:wait_for_content)

        waiter.wait
      end

      context 'when the option disallowing fixtures ejection is not passed' do
        it 'ejects fixtures' do
          expect(fixtures_manager).to receive(:eject)

          waiter.wait
        end
      end

      context 'when the option disallowing fixtures ejection is passed' do
        before do
          options.stub(:waiter_options).and_return(eject_cassettes: false)
        end

        it 'does not eject fixtures' do
          expect(fixtures_manager).to_not receive(:eject)

          waiter.wait
        end
      end
    end

    context 'when a waiter is not defined' do
      it 'the fixtures handler does not eject fixtures' do
        expect(fixtures_manager).to_not receive(:eject)

        waiter.wait
      end
    end
  end

  describe '#with_new_options' do
    let(:new_options) { 'some new options' }

    it 'initializes a new instance of the waiter' do
      subject

      expect(described_class).to receive(:new).with(
        node, fixtures_manager, new_options
      )

      waiter.with_new_options(new_options)
    end
  end
end