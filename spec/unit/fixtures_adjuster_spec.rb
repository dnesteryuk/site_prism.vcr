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

  describe '#replace' do
    before do
      subject.stub(:fixtures).and_return 'some fixtures'
    end

    it 'should replace fixtures' do
      fixtures_handler.should_receive(:apply).with('some fixtures', :replace)

      subject.replace
    end
  end

  describe '#union' do
    before do
      subject.stub(:fixtures).and_return 'some fixtures'
    end

    it 'should union fixtures' do
      fixtures_handler.should_receive(:apply).with('some fixtures', :union)

      subject.union
    end
  end
end