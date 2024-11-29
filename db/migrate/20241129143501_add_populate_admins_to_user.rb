class AddPopulateAdminsToUser < ActiveRecord::Migration[7.0]
  def up
    User.reset_column_information 
    admin = User.find_by(email: "aarfee04@gmail.com")
    if admin
      admin.update(permission_level: 1)
    else
      puts "No user found with the email 'aarfee04@gmail.com'"
    end
  end

  def down
    admin = User.find_by(email: "aarfee04@gmail.com")
    admin&.update(permission_level: nil)
  end
end
