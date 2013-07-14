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
      expect(SitePrism::Vcr::FixturesHandler).to receive(:new).with(options)

      subject
    end
  end

  describe '#fixtures' do
    let(:raw_fixtures) { 'some fixtures' }

    it 'adds fixtures' do
      expect(fixtures_handler).to receive(:add_fixtures).with(raw_fixtures)

      subject.fixtures(raw_fixtures)
    end
  end

  describe '#home_path' do
    let(:raw_home_path) { 'some home path' }

    it 'defines a default home path' do
      expect(options).to receive(:home_path=).with(raw_home_path)

      subject.home_path(raw_home_path)
    end
  end

  describe '#path' do
    it 'adds fixtures into container' do
      expect(fixtures_handler).to receive(:add_fixtures).with([
        'some/path/test_fixture1', 'some/path/test_fixture2'
      ])

      subject.path 'some/path', ['test_fixture1', 'test_fixture2']
    end

    it 'does not add additional "/" if the path name ends with "/"' do
      expect(fixtures_handler).to receive(:add_fixtures).with([
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
    let(:options) { double('waiter='.to_sym => true, 'waiter_options='.to_sym => true) }

    it 'defines a new waiter' do
      expect(options).to receive(:waiter=).with(kind_of(Proc))

      subject.waiter { 'some waiter here' }
    end

    it 'defines an options for a waiter' do
      expect(options).to receive(:waiter_options=).with(eject_cassettes: false)

      subject.waiter(eject_cassettes: false) { 'some waiter here' }
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
      expect(SitePrism::Vcr::Fixtures).to receive(:new).with(raw_fixtures).and_return(fixtures)

      expect(subject.prepared_fixtures).to eq(fixtures)
    end
  end
end