module Authorize
  class PolicyBase
    def initialize(klass_self:, klass_name_underscored:)
      self.class.send(:define_method, klass_name_underscored) do
        klass_self
      end
    end

    def yes
      Authorize::PolicyResponse.yes
    end

    def no(*params)
      Authorize::PolicyResponse.no(*params)
    end
  end
end
