class MethodSelector
  attr_reader :klass

  def initialize(klass)
    @klass = klass
  end

  def select_method_names_by_source_location(source_locations)
    instance_method_names = klass.instance_methods(false)
    instance_method_names.map do |method_name|
      source_location_file = klass.instance_method(method_name).source_location.first
      # next unless source_location_file.start_with?(*source_locations)
  
      method_name
    end.compact
    # NOTE: nextを使ったらnilが配列に入って返ってくるので、compactでnilを除外する
  end
end
  