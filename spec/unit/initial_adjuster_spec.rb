require 'spec_helper'

describe SitePrism::Vcr::InitialAdjuster do
  let(:options)          { double }
  let(:fixtures_handler) { double }

  subject { described_class.new(options) }

  before do
    SitePrism::Vcr::FixturesHandler.stub(:new).and_return(fixtures_handler)
  end

  describe '.new' do
    it 'initializes the fixtures handler' do
      SitePrism::Vcr::FixturesHandler.should_receive(:new).with(options)

      subject
    end
  end

  describe '#fixtures' do
    let(:raw_fixtures) { 'some fixtures' }

    it 'adds fixtures' do
      fixtures_handler.should_receive(:add_fixtures).with(raw_fixtures)

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
      fixtures_handler.should_receive(:add_fixtures).with([
        'some/path/test_fixture1', 'some/path/test_fixture2'
      ])

      subject.path 'some/path', ['test_fixture1', 'test_fixture2']
    end

    it 'does not add additional "/" if the path name ends with "/"' do
      fixtures_handler.should_receive(:add_fixtures).with([
        'some/path/test_fixture1'
      ])

      subject.path 'some/path/', ['test_fixture1']
    end

    context 'when a home path is used in cassettes list' do
      it 'raises an error about wrong using of "path" method' do
        msg = "You cannot use the home path while listing fixtures in the 'path' method. " <<
          "Please, use 'fixtures' method for 'test_fixture2, test_fixture3' fixtures or " <<
          "you can additionally use the 'path' method where you will specify a home path as a path name." <<
          "Example: path('~/', ['test_fixture2', 'test_fixture3'])"

        expect {
          subject.path 'some/path', ['test_fixture1', '~/test_fixture2', '~/test_fixture3']
        }.to raise_error(ArgumentError, msg)
      end
    end
  end

  describe '#waiter' do
    context 'when a method name is passed' do
      it 'defines a new waiter' do
        options.should_receive(:waiter=).with(:some_waiter)

        subject.waiter :some_waiter
      end
    end

    context 'when a block is passed' do
      it 'defines a new waiter' do
        options.should_receive(:waiter=).with(kind_of(Proc))

        subject.waiter { 'some waiter here' }
      end
    end
  end

  describe '#prepared_fixtures' do
    let(:fixtures)     { double }
    let(:raw_fixtures) { 'some raw fixtures' }

    before do
      SitePrism::Vcr::Fixtures.stub(:new).and_return(fixtures)

      fixtures_handler.stub(:fixtures).and_return(raw_fixtures)
    end

    it 'initializes the fixtures handler' do
      SitePrism::Vcr::Fixtures.should_receive(:new).with(raw_fixtures).and_return(fixtures)

      subject.prepared_fixtures.should eq(fixtures)
    end
  end
end