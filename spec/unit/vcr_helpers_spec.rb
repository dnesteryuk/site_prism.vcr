require 'spec_helper'

describe SitePrism::Vcr::Helpers do
  describe '.eject_all_cassettes' do
    subject { described_class.eject_all_cassettes }

    before do
      VCR.stub(:eject_cassette).and_return(1, 2, 3, false)
    end

    it 'ejects all fixtures from VCR' do
      expect(VCR).to receive(:eject_cassette).exactly(4).times

      subject
    end
  end
end