# frozen_string_literal: true

require "rspec"
require "spec_helper"

RSpec.describe XrayMethodTracer do
  let(:expected_instance_method_definition_path) { %r{methods/instance_method_overrider.rb} }
  let(:expected_class_method_definition_path) { %r{methods/class_method_overrider.rb} }

  describe ".trace" do
    context "引数klassesが存在する場合" do
      let(:klasses) { %w[Human Bird Fish].map { |klass| define_class(klass) } }

      after do
        remove_class("Human")
        remove_class("Bird")
        remove_class("Fish")
      end

      context "インスタンスメソッドのみ存在する場合" do
        before do
          XRayMethodTracer.new(klasses:).trace
        end

        it {
          expect(Human.instance_method(:hello).source_location.first)
            .to match(expected_instance_method_definition_path)
        }

        it {
          expect(Bird.instance_method(:hello).source_location.first)
            .to match(expected_instance_method_definition_path)
        }

        it {
          expect(Fish.instance_method(:hello).source_location.first)
            .to match(expected_instance_method_definition_path)
        }
      end

      context "クラスメソッドのみ存在する場合" do
        before do
          klasses.each { |klass| klass.singleton_class.class_eval { def hello; end } }
          XRayMethodTracer.new(klasses:).trace
        end

        it {
          expect(Human.singleton_class.instance_method(:hello).source_location.first)
            .to match(expected_class_method_definition_path)
        }

        it {
          expect(Bird.singleton_class.instance_method(:hello).source_location.first)
            .to match(expected_class_method_definition_path)
        }

        it {
          expect(Fish.singleton_class.instance_method(:hello).source_location.first)
            .to match(expected_class_method_definition_path)
        }
      end

      context "インスタンスメソッドとクラスメソッドが両方存在する場合" do
        before do
          klasses.each do |klass|
            klass.singleton_class.class_eval { def hello; end }
          end
          XRayMethodTracer.new(klasses:).trace
        end

        it "インスタンスメソッドとクラスメソッドの両方がオーバーライドされる事", :aggregate_failures do
          expect(Human.instance_method(:hello).source_location.first)
            .to match(expected_instance_method_definition_path)
          expect(Human.singleton_class.instance_method(:hello)
            .source_location.first).to match(expected_class_method_definition_path)
        end
      end
    end

    context "引数base_klassesが存在する場合" do
      before do
        define_class_with_subclass("Human", "Woman")
        [Human, Woman].each do |klass|
          klass.singleton_class.class_eval { def hello; end }
        end

        XRayMethodTracer.new(base_klasses: [Human]).trace
      end

      after do
        remove_class("Human")
        remove_class("Woman")
      end

      it "継承されているクラスのインスタンスメソッドがオーバーライドされる事", :aggregate_failures do
        expect(Human.instance_method(:hello).source_location.first)
          .to match(expected_instance_method_definition_path)
        expect(Woman.instance_method(:hello).source_location.first)
          .to match(expected_instance_method_definition_path)
      end

      it "継承されているクラスのクラスメソッドがオーバーライドされる事", :aggregate_failures do
        expect(Human.singleton_class.instance_method(:hello).source_location.first)
          .to match(expected_class_method_definition_path)
        expect(Woman.singleton_class.instance_method(:hello).source_location.first)
          .to match(expected_class_method_definition_path)
      end
    end

    context "引数が存在しない場合" do
      before do
        define_class("Human")
        Human.singleton_class.class_eval { def hello; end }
        XRayMethodTracer.new.trace
      end

      after do
        Object.send(:remove_const, "Human")
      end

      it "メソッドがトレースされない事", :aggregate_failures do
        expect(Human.instance_method(:hello).source_location.first)
          .not_to match(expected_instance_method_definition_path)
        expect(Human.singleton_class.instance_method(:hello).source_location.first)
          .not_to match(expected_instance_method_definition_path)
      end
    end
  end
end
