FactoryGirl.define do
  factory :favorite do
    association  :user
    association  :apartment, :factory => :published_apartment
  end
end
