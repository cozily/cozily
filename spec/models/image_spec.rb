require 'spec_helper'

describe Image do
  it { should belong_to(:apartment, :counter_cache => true) }
  it { should validate_presence_of(:apartment) }
end
