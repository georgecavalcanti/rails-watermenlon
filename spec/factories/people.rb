FactoryBot.define do
  factory :person do
    sequence(:name) { |i| Faker::Name.name }
  end
end
