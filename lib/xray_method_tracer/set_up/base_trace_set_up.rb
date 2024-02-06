# frozen_string_literal: true

require_relative "../methods/instance_method_overrider"
require_relative "../methods/class_method_overrider"
require "active_support/core_ext/class/subclasses"

module SetUp
  class BaseTraceSetUp
    attr_reader :base_klasses, :klasses, :source_locations

    def initialize(base_klasses, klasses, source_locations)
      @base_klasses = base_klasses
      @klasses = klasses
      @source_locations = source_locations
    end

    def apply_trace
      classes_to_override = (base_klasses + klasses).uniq
      classes_to_override.each { |klass| override_methods_in_class(klass) }

      override_methods_in_subclasses if base_klasses.any?
    end

    private

    def override_methods_in_class(klass)
      mod = Methods::InstanceMethodOverrider.new(klass).override!(source_locations)
      klass.prepend(mod)

      singleton_mod = Methods::ClassMethodOverrider.new(klass).override!(source_locations)
      klass.singleton_class.prepend(singleton_mod)
    end

    def override_methods_in_subclasses
      base_klasses.uniq.each do |base_klass|
        base_klass.descendants.each { |klass| override_methods_in_class(klass) }
      end
    end
  end
end
