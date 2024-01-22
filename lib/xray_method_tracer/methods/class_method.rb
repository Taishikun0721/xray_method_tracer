# frozen_string_literal: true

require_relative '../rails/constants'

module Methods
  class ClassMethod
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    # rubocop:disable Metrics/MethodLength
    def override!
      target_class = klass
      target_source_location = Rails::Constant::TARGET_SOURCE_LOCATIONS

      mod = Module.new do
        require 'xray_method_tracers/utils/segment'

        class_method_names = target_class.singleton_class.instance_methods(false)
        class_method_names.each do |method_name|
          method = target_class.singleton_class.instance_method(method_name)
          source_location = method.source_location
          next unless source_location.first.start_with?(*target_source_location)
          define_method(method_name) do |*args, **kwargs, &block|
            subsegment = ServiceObserver.begin_subsegment(
              Utils::Segment.sanitize("CM##{target_class.name}##{method_name}")
            )
            begin
              subsegment.metadata[:args] = Utils::Segment.format_args(args)
              result = if kwargs.empty?
                        super(*args, &block)
                      else
                        subsegment.metadata[:kwargs] = kwargs
                        super(*args, **kwargs, &block)
                      end
            rescue StandardError => e
              subsegment.add_exception(exception: e)
              raise e
            ensure
              ServiceObserver.end_subsegment
            end
            result
          end
        end
      end
      
      klass.singleton_class.prepend(mod)
    end
  end
end
