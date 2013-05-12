require 'spec_helper'

describe SitePrism::Vcr::Adjuster do
  let(:fixtures_handler) { double }
  let(:fixtures)         { 'some fixtures' }
  let(:options)          { double(fixtures: fixtures, waiter: :wait_for_me) }

  subject { described_class.new(options, fixtures_handler) }

  describe '#waiter' do
    it 'defines a new waiter' do
      options.should_receive(:waiter=).with(:some_waiter)

      subject.waiter :some_waiter
    end
  end

  describe '#apply_fixtures' do
    context 'when an action is defined' do
      it 'unions fixtures' do
        subject.union

        fixtures_handler.should_receive(:apply).with(fixtures, :union)

        subject.apply_fixtures
      end

      it 'replaces fixtures' do
        subject.replace

        fixtures_handler.should_receive(:apply).with(fixtures, :replace)

        subject.apply_fixtures
      end
    end

    context 'when an action is not specified' do
      it 'replaces fixtures by default' do
        fixtures_handler.should_receive(:apply).with(fixtures, :replace)

        subject.apply_fixtures
      end
    end
  end
end