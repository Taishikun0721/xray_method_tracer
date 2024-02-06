# frozen_string_literal: true

require_relative "../rails_trace_set_up"
require_relative "../pure_ruby_trace_set_up"

class MethodTraceSetUpFactory
  def self.create(base_klasses, klasses)
    return SetUp::RailsTraceSetUp.new(base_klasses, klasses) if Object.const_defined?("Rails::VERSION")

    SetUp::PureRubyTraceSetUp.new(base_klasses, klasses)
  end
end
