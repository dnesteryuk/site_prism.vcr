require 'spec_helper'

describe SPV::Helpers do
  describe '.eject_all_cassettes' do
    subject { described_class.eject_all_cassettes }

    before do
      VCR.insert_cassette 'arya_stark'
      VCR.insert_cassette 'jon_snow'
    end

    it 'ejects all fixtures from VCR' do
      subject

      expect(VCR.eject_cassette).to be_nil
    end
  end
end