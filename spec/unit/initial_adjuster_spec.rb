require 'spec_helper'

describe SPV::InitialAdjuster do
  let(:converted_fixtures_list) { [] }
  let(:options)                 { double }
  let(:tmp_keeper)              { double(add_fixtures: true) }
  let(:fixtures_converter)      { double(convert_raw: converted_fixtures_list) }

  subject { described_class.new(options) }

  before do
    SPV::Fixtures::TmpKeeper.stub(:new).and_return(tmp_keeper)
    SPV::Fixtures::Converter.stub(:new).and_return(fixtures_converter)
  end

  describe '.new' do
    it 'initializes the fixtures handler' do
      expect(SPV::Fixtures::TmpKeeper).to receive(:new).with(options)

      subject
    end

    it 'initializes the fixtures converter' do
      expect(SPV::Fixtures::Converter).to receive(:new)

      subject
    end
  end

  describe '#fixtures' do
    let(:raw_fixtures)            { 'some fixtures' }
    let(:home_path_modifier)      { double(modify: true) }
    let(:conversted_fixture)      { double }
    let(:converted_fixtures_list) { [conversted_fixture] }

    before do
      SPV::Fixtures::Modifiers::HomePath.stub(:new).and_return(home_path_modifier)
    end

    it 'converts given fixtures' do
      expect(fixtures_converter).to receive(:convert_raw).with(raw_fixtures)

      subject.fixtures(raw_fixtures)
    end

    it 'initializes the home path modifier' do
      expect(SPV::Fixtures::Modifiers::HomePath).to receive(:new).with(options)

      subject.fixtures(raw_fixtures)
    end

    it 'sets a home path for the converted fixture' do
      expect(home_path_modifier).to receive(:modify).with(conversted_fixture)

      subject.fixtures(raw_fixtures)
    end

    it 'adds fixtures' do
      expect(tmp_keeper).to receive(:add_fixtures).with(converted_fixtures_list)

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
    let(:fixture)                 { double(has_link_to_home_path?: false) }
    let(:converted_fixtures_list) { [fixture] }
    let(:options_with_path)       { double('path=' => true) }
    let(:path_modifier)           { double(modify: true) }
    let(:home_path_modifier)      { double(modify: true) }

    before do
      SPV::OptionsWithPath.stub(:new).and_return(options_with_path)
      SPV::Fixtures::Modifiers::Path.stub(:new).and_return(path_modifier)
      SPV::Fixtures::Modifiers::HomePath.stub(:new).and_return(home_path_modifier)
    end

    it 'converts raw fixtures' do
      expect(fixtures_converter).to receive(:convert_raw).with(
        ['test_fixture1']
      )

      subject.path 'path', ['test_fixture1']
    end

    it 'initializes a new object with options' do
      expect(SPV::OptionsWithPath).to receive(:new).with(options)

      subject.path 'path', ['test_fixture1']
    end

    it 'defines path to fixtures' do
      expect(options_with_path).to receive(:path=).with('some path')

      subject.path 'some path', ['test_fixture1']
    end

    it 'initializes the modifier to modify path' do
      expect(
        SPV::Fixtures::Modifiers::Path
      ).to receive(:new).with(options_with_path)

      subject.path 'path', ['test_fixture1']
    end

    it 'initializes the modifier to set home path' do
      expect(
        SPV::Fixtures::Modifiers::HomePath
      ).to receive(:new).with(options_with_path)

      subject.path 'path', ['test_fixture1']
    end

    it 'sets the path to fixture' do
      expect(path_modifier).to receive(:modify).with(fixture)

      subject.path 'path', ['test_fixture1']
    end

    it 'sets the home path to fixture' do
      expect(home_path_modifier).to receive(:modify).with(fixture)

      subject.path 'path', ['test_fixture1']
    end

    it 'adds fixtures into container' do
      expect(tmp_keeper).to receive(:add_fixtures).with(converted_fixtures_list)

      subject.path 'path', ['test_fixture1']
    end

    context 'when a home path is used in fixtures list' do
      let(:fixture2) { double(has_link_to_home_path?: true, name: '~/test_fixture2') }
      let(:fixture3) { double(has_link_to_home_path?: true, name: '~/test_fixture3') }
      let(:converted_fixtures_list) { [fixture, fixture2, fixture3] }

      it 'raises an error about wrong using of "path" method' do
        msg = "You cannot use the home path while listing fixtures in the 'path' method. " <<
          "Please, use 'fixtures' method for 'test_fixture2, test_fixture3' fixtures or " <<
          "you can additionally use the 'path' method where you will specify a home path as a path name." <<
          "Example: path('~/', ['test_fixture2', 'test_fixture3'])"

        expect {
          subject.path 'path', ['test_fixture1']
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
      SPV::Fixtures.stub(:new).and_return(fixtures)

      tmp_keeper.stub(:fixtures).and_return(raw_fixtures)
    end

    it 'initializes the fixtures handler' do
      expect(SPV::Fixtures).to receive(:new).with(raw_fixtures).and_return(fixtures)

      expect(subject.prepared_fixtures).to eq(fixtures)
    end
  end
end