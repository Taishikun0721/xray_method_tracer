# frozen_string_literal: true

require "rspec"
require "spec_helper"
require "xray_method_tracer/set_up/base_trace_set_up"
require "xray_method_tracer/set_up/pure_ruby_trace_set_up"

RSpec.describe SetUp::BaseTraceSetUp do
  let(:expected_instance_method_definition_path) { %r{methods/instance_method_overrider.rb} }
  let(:expected_class_method_definition_path) { %r{methods/class_method_overrider.rb} }

  describe ".apply_trace" do
    context "正常系" do
      before do
        define_class_with_subclass("Human", "Woman")
      end

      after do
        remove_class("Human")
        remove_class("Woman")
      end

      it "override_methods_in_classメソッドが1回呼ばれること" do
        pure_ruby = SetUp::PureRubyTraceSetUp.new([], [Human])
        allow(pure_ruby).to receive(:override_methods_in_class).with(Human)
        pure_ruby.apply_trace
        expect(pure_ruby).to have_received(:override_methods_in_class).with(Human)
      end

      it "override_methods_in_subclassesメソッドが1回呼ばれること" do
        pure_ruby = SetUp::PureRubyTraceSetUp.new([Human], [])
        allow(pure_ruby).to receive(:override_methods_in_subclasses)
        pure_ruby.apply_trace
        expect(pure_ruby).to have_received(:override_methods_in_subclasses)
      end

      # NOTE: 複数回渡したとしても、1度しか呼ばれない事を確認してuniqueされている事を確認している
      it "Humanクラスが2つklassesに渡されても, 1度しか呼ばれない事" do
        pure_ruby = SetUp::PureRubyTraceSetUp.new([], [Human, Human])
        allow(pure_ruby).to receive(:override_methods_in_class).with(Human)
        pure_ruby.apply_trace
        expect(pure_ruby).to have_received(:override_methods_in_class).with(Human)
      end

      it "Humanクラスが2つbase_klassesに渡されても, 1度しか呼ばれない事" do
        pure_ruby = SetUp::PureRubyTraceSetUp.new([Human, Human], [])
        allow(pure_ruby).to receive(:override_methods_in_subclasses)
        pure_ruby.apply_trace
        expect(pure_ruby).to have_received(:override_methods_in_subclasses)
      end

      it "Humanクラスのhelloメソッドにトレースが適用されること" do
        SetUp::PureRubyTraceSetUp.new([], [Human]).apply_trace
        expect(Human.instance_method(:hello).source_location.first)
          .to match(expected_instance_method_definition_path)
      end

      it "Humanクラスが2回指定されても、helloメソッドにトレースが適用されること" do
        SetUp::PureRubyTraceSetUp.new([], [Human, Human]).apply_trace
        expect(Human.instance_method(:hello).source_location.first)
          .to match(expected_instance_method_definition_path)
      end
    end
  end
end
