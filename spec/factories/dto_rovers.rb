# frozen_string_literal: true

FactoryBot.define do
  factory :dto_rover, class: 'Vehicle::DtoRover' do
    initialize_with { new(['5 5', '1 2 N', 'LMLMLMLMM']) }

    trait :second do
      initialize_with { new(['5 5', '3 3 E', 'MMRMMRMRRM']) }
    end
  end
end
