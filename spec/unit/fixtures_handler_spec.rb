require 'spec_helper'

describe SPV::FixturesHandler do
  let(:options)          { double }
  let(:fixtures_handler) { described_class.new(options) }

  describe '#add_fixtures' do
    subject { described_class.new(options) }

    it 'adds new fixtures to the container' do
      subject.add_fixtures(['fixture1'])
      subject.add_fixtures(['fixture2'])

      expect(subject.fixtures).to include('fixture1', 'fixture2')
    end
  end
end