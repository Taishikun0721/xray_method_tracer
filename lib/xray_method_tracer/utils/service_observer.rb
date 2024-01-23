# frozen_string_literal: true

# ServiceObserver
# ===============
# XrayやDatadogなどのツールカスタムパフォーマンス計装をする際に使用するクラス
# ===============
require "aws-xray-sdk"

module Utils
  class ServiceObserver
    class << self
      # カスタム計装をする際には、下記のように記述する事で軽装を実施する事ができる
      # ServiceObserver.capture('segment_name') do
      #  somefunction()
      # end
      def capture(segment_name)
        begin_subsegment(segment_name)
        yield
      ensure
        end_subsegment
      end

      def begin_segment_or_subsegment(segment_name)
        if current_segment?
          begin_subsegment(segment_name)
        else
          begin_segment(segment_name)
        end
      end

      def end_segment_or_subsegment
        if current_segment?
          end_subsegment
        else
          end_segment
        end
      end

      private

      def begin_segment(segment_name)
        XRay.recorder.begin_segment(segment_name)
      end

      def end_segment
        XRay.recorder.end_segment
      end

      def begin_subsegment(segment_name)
        XRay.recorder.begin_subsegment(segment_name)
      end

      def end_subsegment
        XRay.recorder.end_subsegment
      end

      def current_segment
        XRay.recorder.current_segment
      end

      def current_subsegment
        XRay.recorder.current_subsegment
      end

      def current_segment?
        !XRay.recorder.current_segment.nil?
      end

      def current_subsegment?
        !XRay.recorder.current_subsegment.nil?
      end
    end
  end
end
