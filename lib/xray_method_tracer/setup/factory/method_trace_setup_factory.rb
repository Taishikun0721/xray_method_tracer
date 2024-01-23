# frozen_string_literal: true

require_relative "../rails_trace_setup"
require_relative "../pure_ruby_trace_setup"

class MethodTraceSetUpFactory
  def self.create(base_klasses, klasses)
    if defined?(Rails::VERSION)
      SetUp::RailsTraceSetUp.new(base_klasses, klasses)
    else
      SetUp::PureRubyTraceSetUp.new(base_klasses, klasses)
    end
  end
end
