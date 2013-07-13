require 'spec_helper'

class TestPageWithElement
  extend SitePrism::ElementContainer

  class << self
    def element(*); end
  end

  def el_with_options
    'original element with options'
  end

  def test_el; end

  element_with_vcr(:el_with_options, '#selector', fixtures: 'some fixtures') {}
end

describe SitePrism::ElementContainer do
  describe '.element_with_vcr' do
    it 'calls the original element method with given arguments' do
      expect(TestPageWithElement).to receive(:element).with(
        :test_el,
        '#test_selector',
        visible: false
      )

      TestPageWithElement.instance_eval do
        element_with_vcr :test_el, '#test_selector', visible: false
      end
    end

    context 'when a method for getting an element is called' do
      let(:page)   { TestPageWithElement.new }
      let(:vcr_el) { 'vcr element' }

      subject { page.el_with_options }

      it 'initializes a new instance of an element with empty options' do
        expect(SitePrism::Vcr::Element).to receive(:new).with(
          'original element with options', page
        ).and_return(vcr_el)

        expect(subject).to eq(vcr_el)
      end
    end
  end
end