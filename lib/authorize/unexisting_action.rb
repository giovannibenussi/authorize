module Authorize
  class UndefinedAction < StandardError
    def initialize(policy_class_name:, can_method_name:)
      @can_method_name = can_method_name
      @policy_class_name = policy_class_name
    end

    def to_s
      "#{@policy_class_name} does not implements #{can_method_name}"
    end
  end
end
