RSpec.configure do |config|
  config.before(:each) do
    if example.options[:js]
      Capybara.current_driver = :selenium

      Capybara::Driver::RackTest::Node.class_eval do
        alias_method :click, :click_without_javascript_emulation
      end
    end
  end

  config.after(:each) do
    if example.options[:js]
      Capybara.use_default_driver

      Capybara::Driver::RackTest::Node.class_eval do
        alias_method :click, :click_with_javascript_emulation
      end
    end
  end
end
