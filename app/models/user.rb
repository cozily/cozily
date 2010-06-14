class User < ActiveRecord::Base
  include Clearance::User

  has_many :apartments, :dependent => :destroy
  has_many :contacts, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :flags, :dependent => :destroy
  has_many :favorite_apartments, :through => :favorites, :source => :apartment
  has_many :flagged_apartments, :through => :flags, :source => :apartment
end
