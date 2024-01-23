# frozen_string_literal: true

require_relative './base_trace_setup'

module SetUp
  class RailsTraceSetUp < BaseTraceSetUp
    attr_reader :base_klasses, :klasses

    def initialize(base_klasses, klasses)
      Rails.application.eager_load!
      base_klasses.concat([ApplicationController, ApplicationRecord, ApplicationMailer])
      super(base_klasses, klasses)
    end
  end
end
  