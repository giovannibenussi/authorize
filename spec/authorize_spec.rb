RSpec.describe Authorize do
  it 'has a version number' do
    expect(Authorize::VERSION).not_to be nil
  end

  let(:test_class) do
    Class.new do
      include Authorize
    end
  end

  class TestPolicy; end

  let(:klass) { test_class.new }

  it 'infers the policy class name from the class name' do
    expect(klass.policy_class).to eq(TestPolicy)
  end
end
