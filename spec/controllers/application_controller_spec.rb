# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, :controller do
  describe '#before_action' do
    context 'when locality is present' do
      it 'changes I18n locale' do
        subject.params = { locale: :'pt-BR' }
        subject.send(:set_locale)

        expect(I18n.locale).to eq(:'pt-BR')
      end
    end
  end
end
