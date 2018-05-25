FactoryBot.define do
  factory :domain do
    facebook { Faker::Superhero.name }
    twitter { Faker::Superhero.descriptor }
  end
end
