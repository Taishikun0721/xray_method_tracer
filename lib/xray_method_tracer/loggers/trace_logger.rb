# frozen_string_literal: true

require "logger"

module Loggers
  class TraceLogger
    def initialize
      @logger = Logger.new($stdout)
    end

    def debug(message)
      @logger.debug("X-Ray Method Tracer: #{message}")
    end

    def info(message)
      @logger.info("X-Ray Method Tracer: #{message}")
    end
  end
end
