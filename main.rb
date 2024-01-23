# frozen_string_literal: true

require "aws-xray-sdk"
require "xray_method_tracer"
require "byebug"

class Main
  def hello_world
    "hello world"
  end
end

user_config = {
  sampling: true,
  name: "pure_ruby_app",
  daemon_address: "127.0.0.1:2000",
  context_missing: "LOG_ERROR",
  patch: %I[net_http aws_sdk]
}

XRay.recorder.configure(user_config)
XRayMethodTracer.trace(klasses: [Main])

puts Main.new.hello_world
