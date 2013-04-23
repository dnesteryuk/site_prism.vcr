require 'spec_helper'

describe SitePrism::Vcr::FixturesAdjuster do
  let(:fixtures_handler) { double }

  subject { described_class.new fixtures_handler }

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