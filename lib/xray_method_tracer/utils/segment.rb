# frozen_string_literal: true

module Utils
  class Segment
    def self.sanitize(name)
      name.delete("?;*()!$~^<>")
    end

    def self.format_args(args)
      args.map.with_index { |arg, index| ["arg_#{index + 1}", arg] }.to_h
    end
  end
end
