class StationTrain < ActiveRecord::Base
  belongs_to :station
  belongs_to :train

  validates_uniqueness_of :train_id, :scope => :station_id
end