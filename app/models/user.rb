class User < ActiveRecord::Base
  include Clearance::User

  has_many :favorites, :dependent => :destroy
  has_many :favorite_apartments, :through => :favorites, :source => :apartment
end
