FactoryGirl.define do
  sequence :full_address do |n|
    addresses = ["546 Henry St 11231", "151 Huron St 11222", "99 S 3rd St 11211", "111 W 74th St 10023", "268 Bowery 10012"]
    addresses[n % addresses.length]
  end

  factory :building do
    full_address  { Factory.next(:full_address) }
  end
end
