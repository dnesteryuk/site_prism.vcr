require 'spec_helper'

class TestForPathCombiner
  include SitePrism::Vcr::PathCombiner
end

describe SitePrism::Vcr::PathCombiner do
  describe '#path' do
    subject { TestForPathCombiner.new }

    it 'adds fixtures into container' do
      subject.path 'some/path', ['test_fixture1', 'test_fixture2']
      subject.path 'new/path',  ['test_fixture']

      subject.fixtures.should eq([
        'some/path/test_fixture1', 'some/path/test_fixture2',
        'new/path/test_fixture'
      ])
    end
  end
end