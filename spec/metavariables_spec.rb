RSpec.describe Authorize do
  let(:klass) { test_class.new }

  class Post
    include Authorize

    def creable?
      true
    end
  end

  class PostPolicy < Authorize::PolicyBase
    def can_create?
      if post.creable?
        yes
      else
        no
      end
    end
  end

  describe '#can? metavariables' do
    context 'when the action asks for its class name underscored' do
      def execute
        Post.new.can? to: action
      end

      let(:action) { :create }

      it 'can access the caller instance' do
        expect(execute).to eq(true)
      end
    end
  end
end
