require 'authorize/version'
require 'authorize/unexisting_policy'
require 'active_model'
require 'active_support/all'

module Authorize
  def self.included(receiver)
    receiver.send :include, ActiveModel::AttributeMethods
  end

  def policy_class
    policy_class_name.safe_constantize || raise(Authorize::UnexistingPolicy, policy_class_name)
  end

  def policy_class_name
    "#{klass_name.camelize}Policy"
  end

  def klass_name
    self.class.to_s
  end
end
