# frozen_string_literal: true

require_relative '../rails/constants'
require_relative './method_selector'

module Methods
  class ClassMethod
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    # rubocop:disable Metrics/MethodLength
    def override!
      method_selector = MethodSelector.new(klass.singleton_class)
      target_method_names = method_selector.select_method_names_by_source_location(Rails::Constant::TARGET_SOURCE_LOCATIONS)
      target_klass = klass

      Module.new do
        require_relative '../utils/segment'
        require_relative '../utils/service_observer'

        target_method_names.each do |method_name|
          define_method(method_name) do |*args, **kwargs, &block|
            segment = Utils::ServiceObserver.begin_segment_or_subsegment(
              Utils::Segment.sanitize("CM##{target_klass.name}##{method_name}")
            )
            begin
              segment.metadata[:args] = Utils::Segment.format_args(args)
              result = if kwargs.empty?
                        super(*args, &block)
                      else
                        segment.metadata[:kwargs] = kwargs
                        super(*args, **kwargs, &block)
                      end
            rescue StandardError => e
              segment.add_exception(exception: e)
              raise e
            ensure
              Utils::ServiceObserver.end_segment_or_subsegment
            end
            result
          end
        end
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
