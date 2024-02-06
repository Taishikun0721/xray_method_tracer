# frozen_string_literal: true

module Rails
  class Constant
    TARGET_SOURCE_LOCATIONS = [
      "/app/mailers",
      "/app/models",
      "/app/controllers",
      "/app/jobs"
    ].freeze

    def self.target_source_locations
      TARGET_SOURCE_LOCATIONS.map { |path| XRayMethodTracer.path_prefix + path }
    end
  end
end
