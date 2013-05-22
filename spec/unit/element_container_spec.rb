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

  element_with_vcr :el_with_options, '#selector', fixtures: 'some fixtures'
end

describe SitePrism::ElementContainer do
  describe '.element_with_vcr' do
    it 'calls the original element method with given arguments' do
      TestPageWithElement.should_receive(:element).with(:test_el, '#test_selector')

      TestPageWithElement.instance_eval do
        element_with_vcr :test_el, '#test_selector'
      end
    end

    context 'when a method for getting element is called' do
      let(:page)   { TestPageWithElement.new }
      let(:vcr_el) { 'vcr element' }

      subject { page.el_with_options }

      it 'initializes a new instance of a vcr element with empty options' do
        SitePrism::Vcr::Element.should_receive(:new).with(
          'original element with options', page, fixtures: 'some fixtures'
        ).and_return(vcr_el)

        subject.should eq(vcr_el)
      end
    end
  end
end