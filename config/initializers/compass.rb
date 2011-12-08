require 'compass'

Compass.add_project_configuration(File.join(Rails.root.to_s, "config", "compass.rb"))
Compass.configure_sass_plugin!
Compass.handle_configuration_change!
