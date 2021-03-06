require 'spec_helper'

describe SPV::DSL::InitialAdjuster do
  let(:options)          { instance_double('SPV::Options') }
  let(:tmp_keeper)       { instance_double('SPV::Fixtures::TmpKeeper', add_fixtures: true) }
  let(:handled_fixtures) { 'handled fixtures' }
  let(:fixtures_handler) { instance_double('SPV::Fixtures::Handler', handle_raw: handled_fixtures) }

  subject { described_class.new(options) }

  before do
    allow(SPV::Fixtures::TmpKeeper).to receive(:new).and_return(tmp_keeper)
    allow(SPV::Fixtures::Handler).to receive(:new).and_return(fixtures_handler)
  end

  describe '.new' do
    it 'initializes the fixtures tmp keeper' do
      expect(SPV::Fixtures::TmpKeeper).to receive(:new).with(options)

      subject
    end

    it 'initializes the fixtures handler' do
      expect(SPV::Fixtures::Handler).to receive(:new)

      subject
    end
  end

  describe '#fixtures' do
    let(:raw_fixtures)           { 'some fixtures' }
    let(:home_path_modifier)     { double('home path modifier') }
    let(:relative_path_modifier) { double('relative path modifier') }

    before do
      allow(SPV::Fixtures::Modifiers::ShortcutPath).to receive(:new).and_return(home_path_modifier)
      allow(SPV::Fixtures::Modifiers::RelativePath).to receive(:new).and_return(relative_path_modifier)
    end

    it 'initializes the home path modifier' do
      expect(SPV::Fixtures::Modifiers::ShortcutPath).to receive(:new).with(options)

      subject.fixtures(raw_fixtures)
    end

    it 'initializes the relative path modifier' do
      expect(SPV::Fixtures::Modifiers::RelativePath).to receive(:new).with(options)

      subject.fixtures(raw_fixtures)
    end

    it 'handles raw fixtures' do
      expect(fixtures_handler).to receive(:handle_raw).with(
        raw_fixtures,
        [
          home_path_modifier,
          relative_path_modifier
        ]
      )

      subject.fixtures(raw_fixtures)
    end

    it 'adds fixtures' do
      expect(tmp_keeper).to receive(:add_fixtures).with(handled_fixtures)

      subject.fixtures(raw_fixtures)
    end
  end

  describe '#home_path' do
    let(:raw_home_path) { 'some home path' }

    it 'defines a shortcut for a home path' do
      expect(options).to receive(:add_shortcut_path).with(
        '~',
        raw_home_path
      )

      subject.home_path(raw_home_path)
    end
  end

  describe '#shortcut_path' do
    let(:raw_path) { 'some path' }

    it 'defines a shortcut for the path' do
      expect(options).to receive(:add_shortcut_path).with(
        'test_shortcut',
        raw_path
      )

      subject.shortcut_path('test_shortcut', raw_path)
    end
  end

  describe '#path' do
    def set_path
      subject.path 'path', raw_fixtures
    end

    let(:raw_fixtures)       { 'some raw fixtures' }
    let(:options_with_path)  { instance_double('SPV::OptionsWithPath', 'path=' => true) }

    let(:path_modifier)      { double('path modifier') }
    let(:home_path_modifier) { double('home path modifier') }

    before do
      allow(SPV::OptionsWithPath).to receive(:new).and_return(options_with_path)
      allow(SPV::Fixtures::Modifiers::Path).to receive(:new).and_return(path_modifier)
      allow(SPV::Fixtures::Modifiers::ShortcutPath).to receive(:new).and_return(home_path_modifier)
    end

    it 'initializes a new object with options' do
      expect(SPV::OptionsWithPath).to receive(:new).with(options)

      set_path
    end

    it 'defines path to fixtures' do
      expect(options_with_path).to receive(:path=).with('path')

      set_path
    end

    it 'initializes the modifier to modify path' do
      expect(
        SPV::Fixtures::Modifiers::Path
      ).to receive(:new).with(options_with_path)

      set_path
    end

    it 'initializes the modifier to set home path' do
      expect(
        SPV::Fixtures::Modifiers::ShortcutPath
      ).to receive(:new).with(options_with_path)

      set_path
    end

    it 'handles raw fixtures' do
      expect(fixtures_handler).to receive(:handle_raw).with(
        raw_fixtures,
        [
          path_modifier,
          home_path_modifier
        ]
      )

      set_path
    end

    it 'adds fixtures into tmp keeper' do
      expect(tmp_keeper).to receive(:add_fixtures).with(handled_fixtures)

      set_path
    end
  end

  describe '#waiter' do
    let(:options) {
      instance_double(
        'SPV::Options',
        'waiter='.to_sym         => true,
        'waiter_options='.to_sym => true
      )
    }

    it 'defines a new waiter' do
      expect(options).to receive(:waiter=).with(kind_of(Proc))

      subject.waiter { 'some waiter here' }
    end

    it 'defines an options for a waiter' do
      expect(options).to receive(:waiter_options=).with(eject_cassettes: false)

      subject.waiter(eject_cassettes: false) { 'some waiter here' }
    end
  end

  describe '#prepare_fixtures' do
    let(:fixtures)     { double('fixtures') }
    let(:raw_fixtures) { 'some raw fixtures' }

    before do
      allow(SPV::Fixtures).to receive(:new).and_return(fixtures)

      allow(tmp_keeper).to receive(:fixtures).and_return(raw_fixtures)
    end

    it 'initializes the fixtures handler' do
      expect(SPV::Fixtures).to receive(:new).with(raw_fixtures).and_return(fixtures)

      expect(subject.prepare_fixtures).to eq(fixtures)
    end
  end
end