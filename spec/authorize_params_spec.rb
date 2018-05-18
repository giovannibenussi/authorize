RSpec.describe Authorize do
  let(:klass) { test_class.new }

  class AuthorizeParamsSpec
    include Authorize
  end

  class AuthorizeParamsSpecPolicy < Authorize::PolicyBase
    def can_create?(text:)
      if text == 'valid text'
        yes
      else
        no
      end
    end

    def can_update?(name:, last_name: 'benussi')
      if "#{name} #{last_name}" == 'giovanni benussi'
        yes
      else
        no
      end
    end

    def can_delete?(current_user, last_name:, casecmp: true)
      equal_last_name = if casecmp
        current_user.last_name.casecmp?(last_name)
      else
        current_user.last_name == last_name
      end

      if equal_last_name
        yes
      else
        no
      end
    end
  end

  describe '#authorize! params' do
    context 'when the action contains parameters' do
      def execute
        AuthorizeParamsSpec.new.authorize! to: action, text: 'valid text'
      end

      let(:action) { :create }

      it 'can access the parameters' do
        expect(execute).to eq(true)
      end
    end

    context 'when the action contains named parameters' do
      def execute
        AuthorizeParamsSpec.new.can? to: action, name: 'giovanni'
      end

      let(:action) { :update }

      it 'can access the parameters' do
        expect(execute).to eq(true)
      end
    end

    context 'when the action contains both parameters and named parameters' do
      def execute
        current_user = OpenStruct.new(last_name: 'Benussi')
        AuthorizeParamsSpec.new.can? current_user, to: action, last_name: 'benussi', casecmp: true
      end

      let(:action) { :delete }

      it 'can access the parameters' do
        expect(execute).to eq(true)
      end
    end
  end
end
