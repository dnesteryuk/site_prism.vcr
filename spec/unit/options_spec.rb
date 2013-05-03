require 'spec_helper'

describe SitePrism::Vcr::Options do
  describe '.new' do
    context 'when all allowed options are passed' do
      it 'holds the passed options' do
        waiter   = 'some'
        fixtures = 'some fixtures'

        options = described_class.new(
          waiter:       waiter,
          'fixtures' => fixtures
        )

        options.waiter.should eq(waiter)
        options.fixtures.should eq(fixtures)
      end
    end

    context 'when no allowed option is passed' do
      it 'raises an error' do
        expect {
          described_class.new(
            myopt:  true,
            waiter: 'some waiter'
          )
        }.to raise_error(
          ArgumentError,
          "'myopt' is not known option for handling Vcr fixtures"
        )
      end
    end

    context 'when a few no allowed options are passed' do
      it 'raises an error' do
        expect {
          described_class.new(
            myopt:      true,
            test_opt:   false,
            'waiter' => 'some waiter'
          )
        }.to raise_error(
          ArgumentError,
          "'myopt', 'test_opt' are not known options for handling Vcr fixtures"
        )
      end
    end
  end
end