class CreateLogEmailExpiracaos < ActiveRecord::Migration
  def change
    create_table :log_email_expiracaos do |t|
      t.integer :cliente_id

      t.timestamps
    end
    add_index :log_email_expiracaos, :cliente_id
  end
end
