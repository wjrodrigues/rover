# frozen_string_literal: true

FactoryBot.define do
  factory :rover, class: 'Vehicle::Rover' do
    initialize_with { new(x_axis: 1, y_axis: 3, orientation: Vehicle::Rover::NORTH) }

    trait :south do
      orientation { Vehicle::Rover::SOUTH }
    end
  end
end
