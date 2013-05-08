require 'spec_helper'

describe SitePrism::Vcr::Adjuster do
  let(:fixtures_handler) { double }
  let(:fixtures)         { 'some fixtures' }
  let(:options)          { double(waiter: :default_waiter, fixtures: fixtures) }

  subject { described_class.new(options, fixtures_handler) }

  describe '#waiter' do
    it 'defines a new waiter' do
      subject.waiter :some_waiter
      subject.waiter.should eq(:some_waiter)
    end

    it 'returns a default waiter' do
      subject.waiter.should eq(:default_waiter)
    end
  end

  describe '#modify_fixtures' do
    context 'when an action is defined' do
      it 'unions fixtures' do
        subject.union

        fixtures_handler.should_receive(:apply).with(fixtures, :union)

        subject.modify_fixtures
      end

      it 'replaces fixtures' do
        subject.replace

        fixtures_handler.should_receive(:apply).with(fixtures, :replace)

        subject.modify_fixtures
      end
    end

    context 'when an action is not specified' do
      it 'replaces fixtures by default' do
        fixtures_handler.should_receive(:apply).with(fixtures, :replace)

        subject.modify_fixtures
      end
    end
  end
end