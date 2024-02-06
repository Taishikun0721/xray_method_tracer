# frozen_string_literal: true

require "rspec"
require "spec_helper"
require "xray_method_tracer/utils/segment"

RSpec.describe Utils::Segment do
  describe ".build_name" do
    context "正常系" do
      before do
        Object.const_set("Human", Class.new)
        Human.class_eval { def hello; end }
      end

      after do
        Object.send(:remove_const, "Human")
      end

      it "セグメント名を正常に構築できる事" do
        class_name = Human.name
        method_name = Human.instance_method(:hello).name

        expect(described_class.build_name("IM", class_name, method_name)).to eq("IM#Human#hello")
      end
    end
  end

  describe ".sanitize" do
    subject { described_class.sanitize(name) }

    context "引数nameが存在する場合" do
      let(:name) { "test?;*()!$~^<>" }

      it { is_expected.to eq("test") }
    end

    context "引数に該当の文字列が複数含まれている場合" do
      let(:name) { "test?;*()!$~^<>?;*()!$~^<>" }

      it { is_expected.to eq("test") }
    end
  end

  describe ".format_args" do
    subject { described_class.format_args(args) }

    context "引数argsが存在する場合" do
      let(:args) { %w[1 2 3] }

      it { is_expected.to eq({ "arg_1" => "1", "arg_2" => "2", "arg_3" => "3" }) }
    end

    context "引数argsが存在しない場合" do
      let(:args) { [] }

      it { is_expected.to eq({}) }
    end
  end
end
