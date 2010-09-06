class RemoveFieldsFromMessages < ActiveRecord::Migration
  def self.up
    Message.find_all_by_parent_id(nil).each do |message|
      conversation = Conversation.new(:sender_id => message.sender_id,
                                      :receiver_id => message.receiver_id,
                                      :apartment_id => message.apartment_id)
      conversation.send(:create_without_callbacks)
      message.update_attribute(:conversation_id, conversation.id)
      Message.update_all({:conversation_id => conversation.id}, {:parent_id => message.id})
    end
    
    remove_column :messages, :receiver_id
    remove_column :messages, :apartment_id
    remove_column :messages, :parent_id
  end

  def self.down
  end
end
