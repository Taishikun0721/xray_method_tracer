# frozen_string_literal: true

require 'spec_helper'

RSpec.describe XrayMethodTracer do
  describe '.call' do
    context '引数klassesが存在する場合' do
      after do
        Object.send(:remove_const, 'Human')
        Object.send(:remove_const, 'Bird')
        Object.send(:remove_const, 'Fish')
      end

      let(:klasses) { ['Human', 'Bird', 'Fish'].map { |klass| Object.const_set(klass, Class.new) } }
      context 'インスタンスメソッドのみ存在する場合' do
        before do
          klasses.each { |klass| klass.class_eval { def hello; end } }
          XRayMethodTracer.trace(klasses: klasses)
        end

        it { expect(Human.instance_method(:hello).source_location.first).to match(/methods\/instance_method.rb/) }
        it { expect(Bird.instance_method(:hello).source_location.first).to match(/methods\/instance_method.rb/) }
        it { expect(Fish.instance_method(:hello).source_location.first).to match(/methods\/instance_method.rb/) }
      end

      context 'クラスメソッドのみ存在する場合' do
        before do
          klasses.each { |klass| klass.singleton_class.class_eval { def hello; end } }
          XRayMethodTracer.trace(klasses: klasses)
        end

        it { expect(Human.singleton_class.instance_method(:hello).source_location.first).to match(/methods\/class_method.rb/) }
        it { expect(Bird.singleton_class.instance_method(:hello).source_location.first).to match(/methods\/class_method.rb/) }
        it { expect(Fish.singleton_class.instance_method(:hello).source_location.first).to match(/methods\/class_method.rb/) }
      end

      context 'インスタンスメソッドとクラスメソッドが両方存在する場合' do
        before do
          klasses.each { |klass| klass.class_eval { def hello; end } }
          klasses.each { |klass| klass.singleton_class.class_eval { def hello; end } }
          XRayMethodTracer.trace(klasses: klasses)
        end

        it 'インスタンスメソッドとクラスメソッドの両方がオーバーライドされる事' do
          expect(Human.instance_method(:hello).source_location.first).to match(/methods\/instance_method.rb/)
          expect(Human.singleton_class.instance_method(:hello).source_location.first).to match(/methods\/class_method.rb/)
        end
      end
    end

    context '引数base_klassesが存在する場合' do
      context '基底クラスが存在する場合' do
        before do
          Object.const_set('Human', Class.new)
          Object.const_set('Woman', Class.new(Human))
          [Human, Woman].each do |klass|
            klass.class_eval { def hello; end }
            klass.singleton_class.class_eval { def hello; end }
          end

          XRayMethodTracer.trace(base_klasses: [Human])
        end

        after do
          Object.send(:remove_const, 'Human')
          Object.send(:remove_const, 'Woman')
        end

        it '継承されているクラスのインスタンスメソッドがオーバーライドされる事' do
          expect(Human.instance_method(:hello).source_location.first).to match(/methods\/instance_method.rb/)
          expect(Woman.instance_method(:hello).source_location.first).to match(/methods\/instance_method.rb/)
        end

        it '継承されているクラスのクラスメソッドがオーバーライドされる事' do
          expect(Human.singleton_class.instance_method(:hello).source_location.first).to match(/methods\/class_method.rb/)
          expect(Woman.singleton_class.instance_method(:hello).source_location.first).to match(/methods\/class_method.rb/)
        end
      end
    end
  end
end
