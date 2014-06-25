class AddEmailToLogHashEmailAmigo < ActiveRecord::Migration
  def change
    add_column :log_hash_email_amigos, :email, :string
  end
end
