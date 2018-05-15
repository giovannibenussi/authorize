RSpec.describe Authorize do
  class TestPolicy; end

  let(:test_class) do
    class Test
      include Authorize
    end
  end

  let(:klass) { test_class.new }

  describe '#policy_class' do
    it 'infers the policy class name from the class name' do
      expect(klass.policy_class).to eq(TestPolicy)
    end
  end
end
