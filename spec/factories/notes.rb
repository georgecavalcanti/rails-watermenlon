FactoryBot.define do
  factory :note do
    sequence(:name) { |i| Faker::Science.element_subcategory }
    sequence(:content) { |i| Faker::Lorem.paragraphs }
  end
end
