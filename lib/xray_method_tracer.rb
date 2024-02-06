# frozen_string_literal: true

require_relative "./xray_method_tracer/set_up/factory/method_trace_set_up_factory"
require_relative "./xray_method_tracer/loggers/trace_logger"

class XRayMethodTracer
  attr_reader :base_klasses, :klasses

  class << self
    attr_accessor :path_prefix # dockerなどでWORKDIRを変更した場合に対応するためのprefix
  end

  def initialize(base_klasses: [], klasses: [])
    @base_klasses = base_klasses
    @klasses = klasses
  end

  def trace
    if empty_klasses?
      Loggers::TraceLogger.new.warn("At least one klasses or base_klasses is required No Tracing will be done")
      return
    end

    Loggers::TraceLogger.new.info("setup method trace")
    method_trace_setup = MethodTraceSetUpFactory.create(base_klasses, klasses)
    method_trace_setup.apply_trace
    Loggers::TraceLogger.new.info("setup method trace done")
  end

  private

  def empty_klasses?
    base_klasses.empty? && klasses.empty?
  end
end
