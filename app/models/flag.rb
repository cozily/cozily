class Flag < ActiveRecord::Base
  belongs_to :apartment, :counter_cache => true
  belongs_to :user

  validates_uniqueness_of :apartment_id, :scope => :user_id
  validate :ensure_user_is_not_owner

  fires :created,
        :on => :create,
        :actor => :user,
        :secondary_subject => :apartment

  fires :destroyed,
        :on => :destroy,
        :actor => :user,
        :secondary_subject => :apartment

  private
  def ensure_user_is_not_owner
    errors.add(:user, "You can't flag your own apartment") if user == apartment.user
  end
end
