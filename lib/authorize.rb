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

  def is_allowed?(params: [], to:, named_params: {})
    method = "can_#{to.to_s.underscore}?"
    raise Authorize::UndefinedAction.new(policy_class_name: policy_class_name, can_method_name: method) unless policy_class.method_defined?(method)

    # If named_params is an empty hash, an error is raised
    # Apparently this is a bug:
    # https://stackoverflow.com/questions/43024670/passing-an-empty-hash-through-double-splat-in-ruby
    if named_params.any?
      policy_class_instance.send(method, *params, **named_params)
    else
      policy_class_instance.send(method, *params)
    end
  end

  def can?(*params, to:, **named_params)
    is_allowed?(params: params, to: to, named_params: named_params).can?
  end

  alias_method :authorize?, :can?

  def authorize!(*params, to:, **named_params)
    response = is_allowed?(params: params, to: to, named_params: named_params)
    return true if response.can?

    raise Authorize::Unauthorized.new(
      policy_class_name: policy_class_name,
      action: to,
      reason: response.reason
    )
  end

  def policy_class
    @_policy_class ||= policy_class_name.safe_constantize || raise(Authorize::UnexistingPolicy, policy_class_name)
  end

  def policy_class_instance
    @_policy_class_instance ||= policy_class.new(klass_self: self, klass_name_underscored: klass_name_underscored)
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
