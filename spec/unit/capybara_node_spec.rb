require 'spec_helper'

describe Capybara::Node::Element do
  subject(:element) { Capybara::Node::Element.new(stub, stub, stub, stub) }

  describe '#synchronize' do
    let(:result) { 'some res' }

    before do
      element.stub(:origin_synchronize).and_return(result)
    end

    it 'should use the originnal synchronize method' do
      element.should_receive(:origin_synchronize).with('some args')

      element.synchronize('some args')
    end

    it 'should eject all cassettes' do
      VCR.should_receive(:eject_cassette).exactly(3).times.and_return(true, true, false)

      element.synchronize
    end

    it 'should return a result of synchronization' do
      element.synchronize.should eq(result)
    end
  end
end