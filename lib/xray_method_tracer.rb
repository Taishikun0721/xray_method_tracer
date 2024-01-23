# frozen_string_literal: true

require_relative "./xray_method_tracer/setup/factory/method_trace_setup_factory"
require_relative "./xray_method_tracer/loggers/trace_logger"

class XRayMethodTracer
  def self.trace(base_klasses: [], klasses: [])
    Loggers::TraceLogger.new.info("setup method trace")
    method_trace_setup = MethodTraceSetUpFactory.create(base_klasses, klasses)
    method_trace_setup.apply_trace
    Loggers::TraceLogger.new.info("setup method trace done")
  end
end
