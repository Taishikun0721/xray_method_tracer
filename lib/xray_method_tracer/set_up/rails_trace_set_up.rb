# frozen_string_literal: true

require_relative "./base_trace_set_up"

module SetUp
  class RailsTraceSetUp < BaseTraceSetUp
    attr_reader :base_klasses, :klasses, :source_locations

    def initialize(base_klasses, klasses)
      @source_locations = Rails::Constant.target_source_locations
      super(base_klasses, klasses, source_locations)
    end
  end
end
