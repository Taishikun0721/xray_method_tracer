# frozen_string_literal: true

require_relative "../rails/constants"
require_relative "./method_selector"

module Methods
  class ClassMethodOverrider
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    # rubocop:disable Metrics/MethodLength
    def override!(source_locations)
      target_method_names = MethodSelector.new(klass.singleton_class).select_method_names_by_source_location(
        source_locations
      )
      target_klass = klass

      Module.new do
        require_relative "../utils/segment"
        require_relative "../utils/service_observer"

        target_method_names.each do |method_name|
          define_method(method_name) do |*args, **kwargs, &block|
            begin
              segment = Utils::ServiceObserver.begin_subsegment(
                Utils::Segment.build_name("CM", target_klass.name, method_name)
              )
              segment.add_metadata(:args, Utils::Segment.format_args(args))
              result = if kwargs.empty?
                         super(*args, &block)
                       else
                         segment.metadata[:kwargs] = kwargs
                         super(*args, **kwargs, &block)
                       end
            rescue StandardError => e
              segment.add_exception(e)
              raise e
            ensure
              Utils::ServiceObserver.end_subsegment
            end
            result
          end
        end
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
