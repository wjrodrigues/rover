# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tracker::Track, :lib do
  describe '#notify' do
    context 'when has optional data' do
      it 'calls method' do
        expect(Tracker::Track).to receive(:notify).with(StandardError, { data: :any })

        described_class.notify(StandardError.new(''), { data: :any })
      end
    end
  end
end
