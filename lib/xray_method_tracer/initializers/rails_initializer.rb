# frozen_string_literal: true

require_relative './base_initializer'

module Initializer
  class RailsInitializer < BaseInitializer
    attr_reader :base_klasses

    def initialize
      Rails.application.eager_load!

      @base_klasses = []
      @base_klasses << ApplicationController
      @base_klasses << ApplicationRecord
      @base_klasses << ApplicationMailer      
    end
  end
end
  