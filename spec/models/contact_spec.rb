require 'spec_helper'

describe Contact do
  it { should belong_to(:user) }

  [:name, :user].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
