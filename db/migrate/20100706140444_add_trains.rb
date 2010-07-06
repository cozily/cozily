class AddTrains < ActiveRecord::Migration
  def self.up
    %w{1 2 3 4 5 6 7 9 A B C D E F G J L M N Q R S V W Z}.each do |train|
      Train.create(:name => train)
    end
  end

  def self.down
    Train.delete_all
  end
end
