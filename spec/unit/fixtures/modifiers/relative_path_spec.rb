require 'spec_helper'

describe SPV::Fixtures::Modifiers::RelativePath do
  describe '#modify' do
    let(:fixture) { instance_double('SPV::Fixture', name: 'some_dir/next_dir/../test') }

    subject { described_class.new(double) }

    it 'moves up on one level in the hierarchy of directories' do
      expect(fixture).to receive(:path=).with('some_dir/test')

      subject.modify(fixture)
    end

    it 'moves up on 2 levels in the hierarchy of directories' do
      fixture.stub(:name).and_return('parent_dir/some_dir/next_dir/../../test')

      expect(fixture).to receive(:path=).with('parent_dir/test')

      subject.modify(fixture)
    end
  end
end