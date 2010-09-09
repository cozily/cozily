Factory.sequence :email do |n|
  "user#{n}@example.com"
end

Factory.define :user do |user|
  user.first_name            { Faker::Name.first_name }
  user.last_name             { Faker::Name.last_name }
  user.email                 { Factory.next :email }
  user.password              { "password" }
  user.password_confirmation { "password" }
  user.roles                 { [Role.find_by_name("finder")] }
end

Factory.define :email_confirmed_user, :parent => :user do |user|
  user.email_confirmed { true }
end
