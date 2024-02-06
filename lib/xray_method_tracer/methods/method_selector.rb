# frozen_string_literal: true

class MethodSelector
  attr_reader :klass

  def initialize(klass)
    @klass = klass
  end

  def select_method_names_by_source_location(source_locations)
    all_instance_method_names = klass.instance_methods(false)
    return all_instance_method_names if source_locations.empty?

    all_instance_method_names.map do |method_name|
      source_location = klass.instance_method(method_name).source_location.first
      next unless source_location.start_with?(*source_locations)

      method_name
    end.compact
    # NOTE: nextを使ったらnilが配列に入って返ってくるので、compactでnilを除外する
  end
end
