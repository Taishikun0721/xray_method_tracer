# frozen_string_literal: true

module ClassDefinitionSupport
  def define_class(class_name)
    klass = Object.const_set(class_name, Class.new)
    klass.class_eval { def hello; end }
    klass
  end

  def define_class_with_subclass(parent_class_name, sub_class_name)
    parent = Object.const_set(parent_class_name, Class.new)
    parent.class_eval { def hello; end }

    sub = Object.const_set(sub_class_name, Class.new(parent))
    sub.class_eval { def hello; end }
  end

  def remove_class(class_name)
    Object.send(:remove_const, class_name)
  end
end
