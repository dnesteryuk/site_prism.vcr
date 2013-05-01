require 'spec_helper'

class TestPageWithElement
  extend SitePrism::ElementContainer

  class << self
    def element(*); end
  end

  def el_without_options
    'original container element without options'
  end

  def test_el; end

  element_with_vcr :el_without_options, '#selector'
end

class TestSectionWithElement < TestPageWithElement
  def parent; end

  def el_with_options
    'original container element with options'
  end

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
      let(:vcr_el) { 'vcr element' }

      context 'when it is a page' do
        let(:page) { TestPageWithElement.new }
        subject    { page.el_without_options }

        it 'initializes a new instance of a vcr element with empty options' do
          SitePrism::Vcr::Element.should_receive(:new).with(
            'original container element without options', page, {}
          ).and_return(vcr_el)

          subject.should eq(vcr_el)
        end
      end

      context 'when it is a section' do
        let(:parent)  { 'parent' }
        let(:section) { TestSectionWithElement.new }

        subject { section.el_with_options }

        it 'initializes a new instance of a vcr element with additional options' do
          section.stub(:parent).and_return(parent)

          SitePrism::Vcr::Element.should_receive(:new).with(
            'original container element with options', parent, fixtures: 'some fixtures'
          ).and_return(vcr_el)

          subject.should eq(vcr_el)
        end
      end
    end
  end
end