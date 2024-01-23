# frozen_string_literal: true

require_relative "./base_trace_setup"

module SetUp
  attr_reader :base_klasses, :klasses

  class PureRubyTraceSetUp < BaseTraceSetUp; end
end
