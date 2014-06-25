class AddCpfToLogHashEmailAmigo < ActiveRecord::Migration
  def change
    add_column :log_hash_email_amigos, :cpf, :string
  end
end
