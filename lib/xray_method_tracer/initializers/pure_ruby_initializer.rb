# frozen_string_literal: true

require_relative './base_initializer'

module Initializer
  attr_reader :base_klasses

  class PureRubyInitializer < BaseInitializer
    def initialize()
      @base_klasses = []
    end 
  end
end
