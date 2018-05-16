RSpec.describe Authorize do
  let(:klass) { test_class.new }

  class ParamsSpecClass
    include Authorize
  end

  class ParamsSpecClassPolicy < Authorize::PolicyBase
    def can_create?(text)
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

    def can_delete?(name, last_name:, upcase: true)
      full_name = "#{name} #{last_name}"
      full_name.upcase! if upcase

      if full_name == 'GIOVANNI BENUSSI'
        yes
      else
        no
      end
    end
  end

  describe '#authorize! params' do
    context 'when the action contains parameters' do
      def execute
        ParamsSpecClass.new.authorize! action, 'valid text'
      end

      let(:action) { :create }

      it 'can access the parameters' do
        expect(execute).to eq(true)
      end
    end

    context 'when the action contains named parameters' do
      def execute
        ParamsSpecClass.new.can? action, name: 'giovanni'
      end

      let(:action) { :update }

      it 'can access the parameters' do
        expect(execute).to eq(true)
      end
    end

    context 'when the action contains both parameters and named parameters' do
      def execute
        ParamsSpecClass.new.can? action, 'giovanni', last_name: 'benussi'
      end

      let(:action) { :delete }

      it 'can access the parameters' do
        expect(execute).to eq(true)
      end
    end
  end
end
