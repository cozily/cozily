require 'spec_helper'

describe Station do
  it { should validate_presence_of :name }
end
