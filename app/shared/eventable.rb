module Eventable
  def self.included(base)
    base.class_eval do
      has_many :actor_timeline_events,
               :class_name => "TimelineEvent",
               :dependent  => :destroy,
               :as         => :subject

      has_many :subject_timeline_events,
               :class_name => "TimelineEvent",
               :dependent  => :destroy,
               :as         => :subject

      has_many :secondary_subject_timeline_events,
               :class_name => "TimelineEvent",
               :dependent  => :destroy,
               :as         => :secondary_subject
    end
  end
end
