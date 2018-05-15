RSpec.describe Authorize do
  let(:klass) { test_class.new }

  describe '#policy_class' do
    context 'when the associated policy class exists' do
      class ClassWithPolicyPolicy; end

      let(:test_class) do
        class ClassWithPolicy
          include Authorize
        end
      end

      it 'returns the policy class' do
        expect(klass.policy_class).to eq(ClassWithPolicyPolicy)
      end
    end

    context 'when the associated policy class does not exists' do
      let(:test_class) do
        class ClassWithoutPolicy
          include Authorize
        end
      end

      it 'raises an Authorize::UnexistingPolicy error' do
        expect { klass.policy_class }.to raise_error(Authorize::UnexistingPolicy)
      end
    end
  end
end
