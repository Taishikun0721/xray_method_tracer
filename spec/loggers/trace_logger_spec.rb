# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe Loggers::TraceLogger do
  let(:logger) { described_class.new }

  describe "#debug" do
    it "標準出力にログメッセージが出力される事" do
      expect { logger.debug("test message") }.to output(/X-Ray Method Tracer: test message/).to_stdout_from_any_process
    end
  end

  describe "#info" do
    it "標準出力にログメッセージが出力される事" do
      expect { logger.info("test message") }.to output(/X-Ray Method Tracer: test message/).to_stdout_from_any_process
    end
  end

  describe "#warn" do
    it "標準出力にログメッセージが出力される事" do
      expect { logger.warn("test message") }.to output(/X-Ray Method Tracer: test message/).to_stdout_from_any_process
    end
  end
end
