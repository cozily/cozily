Date::Format::STYLE[:slash] = :mdy

# Date / Time formats
::Date::DATE_FORMATS[:mdy] = "%m/%d/%Y"
::Time::DATE_FORMATS[:mdy] = "%m/%d/%Y"
::Date::DATE_FORMATS[:dash_mdy] = "%m-%d-%y"
::Time::DATE_FORMATS[:dash_mdy] = "%m-%d-%y"
::Date::DATE_FORMATS[:logger] = "%Y-%m-%d"
::Time::DATE_FORMATS[:logger] = "%Y-%m-%d %r %Z"
::Date::DATE_FORMATS[:msft_json] = "\/Date(%s%L%z)\/"
::Time::DATE_FORMATS[:msft_json] = "\/Date(%s%L%z)\/"

# Date-only formats
::Date::DATE_FORMATS[:quick] = "%b %e, %Y"

# Time-only formats
::Time::DATE_FORMATS[:time_of_day] = "%I:%M %P"
::Time::DATE_FORMATS[:mdy_with_time] = "%m/%d/%Y %I:%M %P"
::Time::DATE_FORMATS[:mdy_time_with_zone] = "%m/%d/%Y %I:%M %P %Z"
::Time::DATE_FORMATS[:mdy_time_with_ms] = "%Y-%m-%d %H:%M:%S.%6N"
::Time::DATE_FORMATS[:readable_date_with_time_and_zone] = "%B %e, %Y at %I:%M %P (%Z)"

# Defaults
::Time::DATE_FORMATS[:default] = ::Time::DATE_FORMATS[:mdy_with_time]
::Date::DATE_FORMATS[:default] = ::Time::DATE_FORMATS[:mdy]
