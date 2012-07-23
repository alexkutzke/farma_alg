FactoryGirl.define do
  factory :user do
    name 'SomeName'
    email 'user@example.org'
    password 'password'
    password_confirmation 'password'
  end
end
