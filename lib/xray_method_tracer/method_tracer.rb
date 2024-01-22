# frozen_string_literal: true

require_relative './initializers/factory/initializer_factory'
require_relative './loggers/trace_logger'

class MethodTracer
  @base_klasses = []

  def self.call
    Loggers::TraceLogger.new.info('initializing...')
    initializer = InitializerFactory.create
    initializer.call
    Loggers::TraceLogger.new.info('initialized.')
  end
end
