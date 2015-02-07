require 'spec_helper'

describe SPV::Fixture do
  describe '#name' do
    subject { described_class.new(name) }

    context 'when there is only a name' do
      let(:name) { 'test' }

      it 'has correct name' do
        expect(subject.name).to eq('test')
      end
    end

    context 'when there is a name with path' do
      let(:name) { 'parent_dir/test' }

      it 'has correct name' do
        expect(subject.name).to eq('parent_dir/test')
      end
    end

    context 'when there is a name with a home path' do
      let(:name) { '~/test' }

      it 'has correct name' do
        expect(subject.name).to eq('~/test')
      end
    end
  end

  describe '#path=' do
    subject { described_class.new('somename') }

    it 'have a path object' do
      subject.path = 'somepath/'

      expect(subject.path).to be_an_instance_of(Pathname)
      expect(subject.path.to_path).to eq('somepath/')
    end
  end

  describe '#prepend_path' do
    context 'when a fixture name contains a subpath' do
      subject { described_class.new('subpath/somename') }

      it 'prepends a path to a current subpath' do
        subject.prepend_path 'somepath'


        expect(subject.path).to be_an_instance_of(Pathname)
        expect(subject.path.to_path).to eq('somepath/subpath')
      end
    end
  end

  describe '#set_home_path' do
    context 'when a simple shortcut is used' do
      it 'defines a new name with a replaced shortcut path' do
        fixture = described_class.new(':shortcut/fixture_name')

        expect(fixture).to receive(:path=).with('my_home_path/')

        fixture.set_home_path('my_home_path/')
      end

      it 'defines a new name with a replaced shortcut path and keeps a path to subdirectory' do
        fixture = described_class.new(':shortcut/sub/fixture_name')

        expect(fixture).to receive(:path=).with('my_home_path/sub')

        fixture.set_home_path('my_home_path/')
      end
    end

    context 'when a home path is used' do
      it 'defines a new name with a replaced home path symbol' do
        fixture = described_class.new('~/fixture_name')

        expect(fixture).to receive(:path=).with('my_home_path/')

        fixture.set_home_path('my_home_path/')
      end

      it 'defines a new name with replaced a home path symbol and keeps a path to subdirectory' do
        fixture = described_class.new('~/sub/fixture_name')

        expect(fixture).to receive(:path=).with('my_home_path/sub')

        fixture.set_home_path('my_home_path/')
      end
    end
  end

  describe '#shortcut_path' do
    context 'when a fixture has a shortcut' do
      it 'returns "~" for "~/some"' do
        expect(
          described_class.new('~/some').shortcut_path
        ).to eq('~')
      end

      it 'returns "path" for ":path/some"' do
        expect(
          described_class.new(':path/some').shortcut_path
        ).to eq('path')
      end
    end

    context 'when a fixture has not a shortcut' do
      it 'returns nil' do
        expect(
          described_class.new('some').shortcut_path
        ).to be_nil
      end
    end
  end

  describe '#clean_name' do
    subject { described_class.new('~/fixture_name') }

    it 'returns a name without a home path' do
      expect(subject.clean_name).to eq('fixture_name')
    end
  end
end