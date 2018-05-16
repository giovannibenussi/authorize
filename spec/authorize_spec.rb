RSpec.describe Authorize do
  let(:klass) { test_class.new }

  class CustomClass
    include Authorize
  end

  class CustomClassPolicy < Authorize::PolicyBase
    def can_create?
      yes
    end

    def can_delete?
      no because: 'a user is not allowed to delete custom classes'
    end
  end

  def execute
    CustomClass.new.authorize! action
  end

  describe '#authorize' do
    context 'when the asked action exists' do
      context 'when the action returns yes' do
        let(:action) { :create }

        it 'does not raise error' do
          expect { execute }.not_to raise_error
        end
      end

      context 'when the action returns no' do
        let(:action) { :delete }

        it 'raises a Authorize::Unauthorized error' do
          expect { execute }.to raise_error(Authorize::Unauthorized, 'can not perform the delete action because a user is not allowed to delete custom classes')
        end
      end
    end

    context 'when the asked action does not exist' do
      let(:action) { :unexisting_action }

      it 'raises a Authorize::UndefinedAction error' do
        expect { execute }.to raise_error(Authorize::UndefinedAction)
      end
    end
  end
end
