# frozen_string_literal: true

require_relative "./base_trace_set_up"

module SetUp
  attr_reader :base_klasses, :klasses, :source_locations

  class PureRubyTraceSetUp < BaseTraceSetUp
    def initialize(base_klasses, klasses, source_locations = [])
      super(base_klasses, klasses, source_locations)
    end
  end
end
