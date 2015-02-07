require_relative '../mixins/page'

SitePrism::Page.send(:include, SPV::Mixins::Page)