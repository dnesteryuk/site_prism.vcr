require 'forwardable'

require_relative './element'

module SPV
  module Mixins
    module Page
      def self.included(klass)
        klass.extend(Element)
        klass.extend(ClassMethods)

        klass.send(:include, InstanceMethods)
        klass.instance_variable_set(:@vcr_child_adjusters, [])
      end

      module ClassMethods
        attr_reader :vcr_adjuster, :vcr_child_adjusters

        def inherited(subclass)
          # This code is required to allow subpages to inherit
          # a defined adjuster block. Otherwise, that block should be
          # duplicated in a subpage as well.
          subclass.instance_variable_set(:@vcr_adjuster,        @vcr_adjuster)
          subclass.instance_variable_set(:@vcr_child_adjusters, @vcr_child_adjusters.dup)
        end

        def vcr_options_for_load(&block)
          @vcr_adjuster = block
        end

        def adjust_parent_vcr_options(&block)
          raise ArgumentError.new(
            'There is not any Vcr options defined for the parent class'
          ) unless self.vcr_adjuster

          self.vcr_child_adjusters << block
        end
      end

      module InstanceMethods
        def load_and_apply_vcr(*args, &block)
          shift_event { load(*args) }.apply_vcr(&block)
        end

        def shift_event(&block)
          vcr_applier.shift_event(&block)
        end

        private
          def vcr_applier
            @vcr_applier ||= begin
              applier = SPV::Applier.new(
                self,
                &self.class.vcr_adjuster
              )

              self.class.vcr_child_adjusters.each do |block|
                applier.alter_fixtures(&block)
              end

              applier
            end
          end
      end
    end
  end
end