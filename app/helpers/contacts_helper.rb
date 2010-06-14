module ContactsHelper
  def contact_text
    current_user.contacts.present? ? "Or add a new contact" : "Contact"
  end
end