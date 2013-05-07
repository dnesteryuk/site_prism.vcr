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

  describe '#home_path' do
    let(:raw_home_path) { 'some home path' }

    it 'defines a default home path' do
      options.should_receive(:home_path=).with(raw_home_path)

      subject.home_path(raw_home_path)
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