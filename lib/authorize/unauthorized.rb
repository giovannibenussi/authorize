module Authorize
  class Unauthorized < StandardError
    def initialize(policy_class_name:, action:, reason: '')
      @action = action
      @policy_class_name = policy_class_name
      @reason = reason
    end

    def to_s
      message = "can not perform the #{@action} action"
      message += " because #{@reason}" if @reason.present?
      message
    end
  end
end
