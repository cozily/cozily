require 'spec_helper'

describe Message do
  [:apartment, :sender, :receiver].each do |attr|
    it { should belong_to(attr) }
  end

  [:apartment, :body, :sender, :receiver].each do |attr|
    it { should validate_presence_of(attr) }
  end
end
