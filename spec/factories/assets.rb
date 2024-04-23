FactoryBot.define do
  factory :asset do
    sequence(:name) { |i| Faker::Vehicle.make + "#{i}" }   
  end
end
