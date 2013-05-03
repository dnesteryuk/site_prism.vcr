require 'spec_helper'

describe SitePrism::Vcr::Adjuster do
  let(:fixtures_handler) { double }
  let(:options)          { double(waiter: :default_waiter) }

  subject { described_class.new fixtures_handler, options}

  describe '#path' do
    it 'should add fixtures into container' do
      subject.path 'some/path', ['test_fixture1', 'test_fixture2']
      subject.path 'new/path',  ['test_fixture']

      subject.fixtures.should eq([
        'some/path/test_fixture1', 'some/path/test_fixture2',
        'new/path/test_fixture'
      ])
    end
  end

  describe '#waiter' do
    it 'should define a new waiter' do
      subject.waiter :some_waiter
      subject.waiter.should eq(:some_waiter)
    end

    it 'should return a default waiter' do
      subject.waiter.should eq(:default_waiter)
    end
  end

  describe '#modify_fixtures' do
    before do
      subject.stub(:fixtures).and_return 'some fixtures'
    end

    context 'when an action is defined' do
      it 'should union fixtures' do
        subject.union

        fixtures_handler.should_receive(:apply).with('some fixtures', :union)

        subject.modify_fixtures
      end

      it 'should replace fixtures' do
        subject.replace

        fixtures_handler.should_receive(:apply).with('some fixtures', :replace)

        subject.modify_fixtures
      end
    end

    context 'when an action is not sepcified' do
      it 'should replace fixtures by default' do
        fixtures_handler.should_receive(:apply).with('some fixtures', :replace)

        subject.modify_fixtures
      end
    end
  end
end