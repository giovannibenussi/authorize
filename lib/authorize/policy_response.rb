module Authorize
  class PolicyResponse
    class << self
      def yes
        new(can: true)
      end

      def no(because: '')
        new(can: false, reason: because)
      end
    end

    attr_reader :reason

    def initialize(can:, reason: '')
      @can    = can
      @reason = reason
    end

    def can?
      @can
    end
  end
end
