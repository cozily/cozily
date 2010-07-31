ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS.merge!(
    :app_short => "%b %e, %Y",
    :app_long => "%b %e, %Y",
    :app_pretty => "%B %e, %Y",
    :app_full => "%A, %B %e, %Y",
    :app_mdy => "%m/%d/%Y",
    :month => "%b",
    :year => "%Y",
    :day => "%e",
    :xml => "%Y-%m-%d"
)

ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
    :app_mdy => "%m/%d/%Y, %I:%M %p",
    :app_short => "%b %e, %Y",
    :app_long => "%b %e, %Y %I:%M %p",
    :app_pretty => "%B %e, %Y %I:%M %p",
    :app_full => "%A, %B %e, %Y %I:%M %p",
    :month => "%b",
    :year => "%Y",
    :day => "%e"
)
