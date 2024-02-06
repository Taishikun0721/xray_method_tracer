# frozen_string_literal: true

require "rspec"
require "spec_helper"
require "xray_method_tracer/set_up/factory/method_trace_set_up_factory"

RSpec.describe MethodTraceSetUpFactory do
  context "引数にbase_klassesとklassesが存在する場合" do
    let(:base_klasses) { %w[Human Bird Fish].map { |klass| define_class(klass) } }
    let(:klasses) { %w[Car Train].map { |klass| define_class(klass) } }

    after do
      remove_class("Human")
      remove_class("Bird")
      remove_class("Fish")
    end

    it "SetUp::PureRubyTraceSetUpのインスタンスが返る事" do
      expect(described_class.create(base_klasses, klasses)).to be_a(SetUp::PureRubyTraceSetUp)
    end
  end

  context "引数にbase_klassesとklassesが存在しない場合" do
    it "引数に関わらずRails::VERSIONの有無でSetUp::RailsTraceSetUpのインスタンスが返る事" do
      expect(described_class.create(nil, nil)).to be_a(SetUp::PureRubyTraceSetUp)
    end
  end
end
