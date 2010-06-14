class Contact < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name, :user
  validates_presence_of :email, :if => Proc.new { |contact| contact.phone.blank? }
  validates_presence_of :phone, :if => Proc.new { |contact| contact.email.blank? }
end
