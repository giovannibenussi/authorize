module Authorize
  class PolicyBase
    def yes
      Authorize::PolicyResponse.yes
    end

    def no(*params)
      Authorize::PolicyResponse.no(*params)
    end
  end
end
