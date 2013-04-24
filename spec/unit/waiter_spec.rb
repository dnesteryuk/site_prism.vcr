require 'spec_helper'

describe SitePrism::Vcr::Waiter do
  let(:node) { double }

  describe '#wait' do
    context 'when a waiter is defined' do
      let(:node)       { double(wait_for_me: true) }
      subject(:waiter) { described_class.new(node, waiter: :wait_for_me) }

      it 'should call waiter to wait until all AJAX requests are finished' do
        node.should_receive(:wait_for_me)

        waiter.wait
      end
    end
  end
end