require 'spec_helper'

describe SitePrism::Vcr::InitialAdjuster do
  let(:options) { double }

  subject { described_class.new(options) }

  describe '#fixtures' do
    let(:raw_fixtures) { 'some fixtures' }

    it 'adds fixtures' do
      options.should_receive(:add_fixtures).with(raw_fixtures)

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

  describe '#path' do
    it 'adds fixtures into container' do
      options.should_receive(:add_fixtures).with([
        'some/path/test_fixture1', 'some/path/test_fixture2'
      ])

      subject.path 'some/path', ['test_fixture1', 'test_fixture2']
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