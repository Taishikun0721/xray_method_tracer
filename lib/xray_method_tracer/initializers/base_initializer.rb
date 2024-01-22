# frozen_string_literal: true

require_relative '../methods/instance_method'
require_relative '../methods/class_method'

module Initializer
  class BaseInitializer
    attr_reader :base_klasses

    def initialize
      @base_klasses = []
    end

    def call
      base_klasses.each do |base_klass|
        base_klasses.concat(base_klass.descendants).each do |klass|
          Methods::InstanceMethod.new(klass).override!
          Methods::ClassMethod.new(klass).override!
        end
      end
    end
  end
end
