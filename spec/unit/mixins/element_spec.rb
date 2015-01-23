require 'spec_helper'

class TestPageWithElement
  extend SPV::Mixins::Element

  class << self
    def element(*); end
  end

  def test_el1; end
  def test_el2
    'original element'
  end

  link_vcr_with_element :test_el2
end

describe SPV::Mixins::Element do
  describe '.element_with_vcr' do
    subject do
      TestPageWithElement.instance_eval do
        element_with_vcr :test_el1, '#test_selector', visible: false
      end
    end

    it 'calls the original element method with given arguments' do
      expect(TestPageWithElement).to receive(:element).with(
        :test_el1,
        '#test_selector',
        visible: false
      )

      subject
    end

    it 'links vcr with an element' do
      expect(TestPageWithElement).to receive(:link_vcr_with_element).with(
        :test_el1
      )

      subject
    end
  end

  describe '.link_vcr_with_element' do
    context 'when a method for getting an element is called' do
      let(:page)   { TestPageWithElement.new }
      let(:vcr_el) { 'vcr element' }

      subject { page.test_el2 }

      it 'initializes a new instance of an element' do
        expect(SPV::Element).to receive(:new).with(
          'original element', page
        ).and_return(vcr_el)

        expect(subject).to eq(vcr_el)
      end
    end
  end
end