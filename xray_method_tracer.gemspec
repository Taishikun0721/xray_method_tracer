# frozen_string_literal: true

require_relative "lib/xray_method_tracer/version"

Gem::Specification.new do |spec|
  spec.name = "xray_method_tracer"
  spec.version = XrayMethodTracer::VERSION
  spec.authors = ["Taishikun0721"]
  spec.email = ["tai0721abc@gmail.com"]
  spec.summary = "Library for Ruby that allows tracing of methods with xray"
  spec.homepage = "https://github.com/Taishikun0721/xray_method_tracer"
  spec.required_ruby_version = ">= 3.0.0"
  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "activesupport", ">= 6.0"
  spec.add_dependency "aws-xray-sdk", "0.15.0"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
  spec.add_development_dependency "rubocop-rspec", "~> 2.2"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
