# By using the symbol ':user', we get Factory Girl to simulate the user model.
FactoryGirl.define do

  factory :user do |user|
    user.name                  "Michael Hartl"
    user.email                 "mhartl@example.com"
    user.password              "foobar"
    user.password_confirmation "foobar"
  end
end

