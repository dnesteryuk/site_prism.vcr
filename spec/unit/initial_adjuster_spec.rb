require 'spec_helper'

describe SitePrism::Vcr::InitialAdjuster do
  let(:options) { double }

  subject { described_class.new(options) }

  describe '#fixtures' do
    let(:raw_fixtures) { 'some fixtures' }

    it 'defines a default fixtures' do
      options.should_receive(:fixtures=).with(raw_fixtures)

      subject.fixtures(raw_fixtures)
    end
  end

  describe '#waiter' do
    let(:raw_waiter) { 'some waiter' }

    it 'defines a default waiter' do
      options.should_receive(:waiter=).with(raw_waiter)

      subject.waiter(raw_waiter)
    end
  end
end