Fabricator(:video) do
  title { Faker::Lorem.words(2).join(" ") }
  description { Faker::Lorem.paragraph(2) }
  category { Fabricate(:category) }
end