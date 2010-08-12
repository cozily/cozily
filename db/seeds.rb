Role.create(:name => "finder")
Role.create(:name => "lister")
Role.create(:name => "admin")

raise "bad seed" unless Role.count == 3

["m9haddad@gmail.com", "todd.persen@gmail.com"].each do |email|
  Role.all.each do |role|
    UserRole.create(:user => User.find_by_email(email), :role => role)
  end
end