Role.create(:name => "finder")
Role.create(:name => "lister")
Role.create(:name => "admin")

raise "bad seed" unless Role.count == 3