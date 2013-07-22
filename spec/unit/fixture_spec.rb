require 'spec_helper'

describe SPV::Fixture do
  describe '#add_path' do
    subject { described_class.new('some name') }

    it 'have added path to a name of fixture' do
      subject.add_path('some path/')

      expect(subject.name).to eq('some path/some name')
    end
  end

  describe '#set_home_path' do
    subject { described_class.new('~/fixture_name') }

    it 'defines a new name with replaced home path symbol' do
      subject.set_home_path('my_home_path/')

      expect(subject.name).to eq('my_home_path/fixture_name')
    end
  end

  describe '#has_link_to_home_path?' do
    it 'returns true when a name of fixture starts with "~/"' do
      expect(
        described_class.new('~/some').has_link_to_home_path?
      ).to be_true
    end

    it 'returns true when a name of fixture does not start with "~/"' do
      expect(
        described_class.new('some').has_link_to_home_path?
      ).to be_false
    end
  end
end