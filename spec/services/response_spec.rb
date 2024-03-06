# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Response, :services do
  describe '#ok?' do
    context 'when there is no error' do
      it 'returns true' do
        response = described_class.new(result: Object.new)

        expect(response.ok?).to be_truthy
      end
    end

    context 'when there has error' do
      it 'returns false' do
        response = described_class.new(error: Object.new)

        expect(response.ok?).to be_falsy
      end
    end
  end

  describe '#result!' do
    context 'when result added' do
      it 'returns result' do
        response = described_class.new

        expect(response.result).to be_nil

        value = Object.new

        expect(response.result!(value)).to be_instance_of(described_class)
        expect(response.result).to eq(value)
      end
    end
  end

  describe '#error!' do
    context 'when error added' do
      it 'returns error' do
        response = described_class.new

        expect(response.error).to be_nil

        err = Object.new

        expect(response.error!(err)).to be_instance_of(described_class)
        expect(response.error).to eq(err)
      end
    end

    context 'when exists i18n' do
      it 'returns translated errorr', locale: :'pt-BR' do
        response = described_class.new

        response.error!('activerecord.errors.messages.record_invalid', { errors: 'any' })
        expect(response.error).to eq('A validação falhou: any')

        response.error!('activerecord.errors.messages.record_invalid')
        expect(response.error).to eq('A validação falhou: %{errors}')
      end
    end
  end
end
