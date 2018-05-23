RSpec.describe Authorize do
  let(:klass) { test_class.new }

  class IsAllowedClass
    include Authorize
  end

  class IsAllowedClassPolicy < Authorize::PolicyBase
    def can_create?
      yes
    end

    def can_update?
      no
    end

    def can_delete?
      no because: 'a user is not allowed to delete custom classes'
    end
  end

  def execute
    IsAllowedClass.new.is_allowed? to: action
  end

  describe '#is_allowed?' do
    context 'when the asked action does not exist' do
      let(:action) { :unexisting_action }

      it 'raises an Authorize::UndefinedAction error' do
        expect { execute }.to raise_error(Authorize::UndefinedAction)
      end
    end

    context 'when the asked action exists' do
      context 'when the action returns yes' do
        let(:action) { :create }

        it 'returns a policy response' do
          expect(execute).to be_an_instance_of(Authorize::PolicyResponse)
        end

        it 'returns a positive policy response' do
          expect(execute.can?).to eq(true)
        end
      end

      context 'when the action returns no' do
        context 'when the response contains a reason' do
          let(:action) { :update }

          it 'returns a policy response' do
            expect(execute).to be_an_instance_of(Authorize::PolicyResponse)
          end

          it 'returns a positive policy response' do
            expect(execute.can?).to eq(false)
          end
        end

        context 'when the response does not contain a reason' do
          let(:action) { :delete }

          it 'returns a policy response' do
            expect(execute).to be_an_instance_of(Authorize::PolicyResponse)
          end

          it 'returns a positive policy response' do
            expect(execute.can?).to eq(false)
          end
        end
      end
    end
  end
end
