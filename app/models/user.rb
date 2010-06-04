class User < ActiveRecord::Base
  include Clearance::User

  has_many :favorites, :dependent => :destroy
  has_many :apartments, :through => :favorites
end
