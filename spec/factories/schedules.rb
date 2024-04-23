FactoryBot.define do
  factory :schedule do
    sequence(:name) { |i| Faker::Science.element_subcategory }
    sequence(:execution_date) { |i| Faker::Date.in_date_period }
  end
end
