require 'spec_helper'

describe TimelineEvent do
  it { should validate_presence_of(:actor) }
end