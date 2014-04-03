require 'spec_helper'

describe SPV::Fixtures::Modifiers::RelativePath do
  describe '#modify' do
    let(:fixture) { instance_double('SPV::Fixture', path: 'top_dir/next_dir/../') }

    subject { described_class.new(double) }

    it 'moves up on one level in the hierarchy of directories' do
      expect(fixture).to receive(:path=).with('top_dir')

      subject.modify(fixture)
    end

    it 'moves up on 2 levels in the hierarchy of directories' do
      fixture.stub(:path).and_return('parent_dir/some_dir/next_dir/../../')

      expect(fixture).to receive(:path=).with('parent_dir')

      subject.modify(fixture)
    end
  end
end