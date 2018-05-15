require 'authorize/version'
require 'active_model'

module Authorize
  def self.included(receiver)
    receiver.send :include, ActiveModel::AttributeMethods
  end

  def policy_class
    TestPolicy
  end
end
