FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    email { 'john.doe@example.com' }
    password { '123456' }
    role { 'admin' }
  end
end
