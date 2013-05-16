require 'spec_helper'

describe SitePrism::Vcr::Adjuster do
  let(:raw_fixtures)  { 'some fixtures' }
  let(:fixtures)      { double }
  let(:options)       do
    double(
      fixtures:       raw_fixtures,
      waiter:         :wait_for_me,
      clean_fixtures: true
    )
  end

  subject { described_class.new(options, fixtures) }

  describe '#waiter' do
    it 'defines a new waiter' do
      options.should_receive(:waiter=).with(:some_waiter)

      subject.waiter :some_waiter
    end
  end

  describe '#replace' do
    let(:replaced_fixtures) { 'replaced fixtures' }

    before do
      fixtures.stub(:replace).and_return(replaced_fixtures)
    end

    it 'replaces fixtures' do
      fixtures.should_receive(:replace).with(raw_fixtures)

      subject.replace
    end

    it 'should clean fixtures in options' do
      options.should_receive(:clean_fixtures)

      subject.replace
    end

    it 'returns a new container with fixtures' do
      subject.replace

      subject.prepared_fixtures.should eq(replaced_fixtures)
    end
  end

  describe '#union' do
    let(:new_fixtures) { 'new fixtures' }

    before do
      fixtures.stub(:union).and_return(new_fixtures)
    end

    it 'replaces fixtures' do
      fixtures.should_receive(:union).with(raw_fixtures)

      subject.union
    end

    it 'should clean fixtures in options' do
      options.should_receive(:clean_fixtures)

      subject.union
    end

    it 'returns a new container with fixtures' do
      subject.union

      subject.prepared_fixtures.should eq(new_fixtures)
    end
  end
end