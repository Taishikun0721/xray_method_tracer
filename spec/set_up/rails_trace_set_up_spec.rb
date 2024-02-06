# frozen_string_literal: true

require "rspec"
require "spec_helper"
require "xray_method_tracer/set_up/rails_trace_set_up"

RSpec.describe SetUp::RailsTraceSetUp do
  describe ".initialize" do
    context "引数が渡されている場合" do
      before do
        define_class("Human")
        XRayMethodTracer.path_prefix = "/app"
      end

      after do
        remove_class("Human")
      end

      it "source_locationsがRails::Constant.target_source_locationsの値である事" do
        rails_set_up = described_class.new([], [Human])
        expect(rails_set_up.source_locations).to eq(Rails::Constant.target_source_locations)
      end
    end
  end
end
