require 'authorize/policy_base'
require 'authorize/policy_response'
require 'authorize/unauthorized'
require 'authorize/version'
require 'authorize/unexisting_action'
require 'authorize/unexisting_policy'
require 'active_model'
require 'active_support/all'

module Authorize
  def self.included(receiver)
    receiver.send :include, ActiveModel::AttributeMethods
  end

  def is_allowed?(action)
    method = "can_#{action.to_s.underscore}?"
    raise Authorize::UndefinedAction.new(policy_class_name: policy_class_name, can_method_name: method) unless policy_class.method_defined?(method)

    policy_class.new.send(method)
  end

  def can?(action)
    is_allowed?(action).can?
  end

  def authorize!(action)
    response = is_allowed?(action)
    return true if response.can?

    raise Authorize::Unauthorized.new(
      policy_class_name: policy_class_name,
      action: action,
      reason: response.reason
    )
  end

  def policy_class
    @_policy_class ||= policy_class_name.safe_constantize || raise(Authorize::UnexistingPolicy, policy_class_name)
  end

  def policy_class_name
    @_policy_class_name ||= "#{klass_name.camelize}Policy"
  end

  def klass_name
    @_klass_name ||= self.class.to_s
  end

  def klass_name_underscored
    @_klass_name_underscored ||= klass_name.underscore
  end
end
