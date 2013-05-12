require 'spec_helper'

describe SitePrism::Vcr::Waiter do
  let(:node)             { double }
  let(:options)          { double(waiter: :wait_for_me) }
  let(:fixtures_handler) { double(eject: true) }
  subject(:waiter)       { described_class.new(node, fixtures_handler, options) }

  describe '#wait' do
    context 'when a waiter is defined' do
      let(:node) { double(wait_for_me: true) }

      it 'calls the waiter to wait until all HTTP interactions are finished' do
        node.should_receive(:wait_for_me)

        waiter.wait
      end

      it 'ejects fixtures' do
        fixtures_handler.should_receive(:eject)

        waiter.wait
      end
    end

    context 'when a waiter is not defined' do
      let(:options) { double(waiter: nil) }

      it 'the fixtures handler does not eject fixtures' do
        fixtures_handler.should_not_receive(:eject)

        waiter.wait
      end
    end
  end

  describe '#with_new_options' do
    let(:options_with_new_waiter) { double(waiter: :wait_for_tom) }

    before do
      @new_waiter = waiter.with_new_options(options_with_new_waiter)
    end

    it 'has a new waiter method' do
      @new_waiter.waiter_method.should eq(:wait_for_tom)
    end

    it 'has the same node' do
      @new_waiter.node.should eq(node)
    end
  end
end