FactoryBot.define do
  factory :item do
    name { 'Test name' }
    description { 'Test description' }
    location { 'Test location' }
    photo { 'https://images.pexels.com/photos/2510067/pexels-photo-2510067.jpeg' }
    price { '999' }
  end
end
