module Authorize
  class UnexistingPolicy < StandardError
    def initialize(policy_class_name)
      @policy_class_name = policy_class_name
    end

    def to_s
      "Unexisting policy class #{@policy_class_name}"
    end
  end
end
