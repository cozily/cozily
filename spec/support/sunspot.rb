RSpec.configure do |config|
  config.before do
    Sunspot.session = SunspotMatchers::SunspotSessionSpy.new(Sunspot.session)
  end

  config.include SunspotMatchers
end
