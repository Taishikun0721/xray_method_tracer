# frozen_string_literal: true

require_relative "../methods/instance_method"
require_relative "../methods/class_method"
require "active_support/core_ext/class/subclasses"

module SetUp
  class BaseTraceSetUp
    attr_reader :base_klasses, :klasses

    def initialize(base_klasses, klasses)
      @base_klasses = base_klasses
      @klasses = klasses
    end

    def apply_trace
      raise "At least one klasses or base_klasses is required" if base_klasses.empty? && klasses.empty?

      classes_to_override = (base_klasses + klasses).uniq
      classes_to_override.each { |klass| override_methods_in_class(klass) }

      override_methods_in_subclasses if base_klasses.any?
    end

    private

    def override_methods_in_class(klass)
      mod = Methods::InstanceMethod.new(klass).override!
      klass.prepend(mod)

      singleton_mod = Methods::ClassMethod.new(klass).override!
      klass.singleton_class.prepend(singleton_mod)
    end

    def override_methods_in_subclasses
      base_klasses.uniq.each do |base_klass|
        base_klass.descendants.each { |klass| override_methods_in_class(klass) }
      end
    end
  end
end
