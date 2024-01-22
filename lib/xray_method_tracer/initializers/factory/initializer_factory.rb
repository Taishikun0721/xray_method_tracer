# frozen_string_literal: true

require_relative '../rails_initializer'
require_relative '../pure_ruby_initializer'

class InitializerFactory
  def self.create
    if defined?(::Rails)
      Initializer::RailsInitializer.new
    else
      Initializer::PureRubyInitializer.new
    end
  end
end
