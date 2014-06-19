class CreateLogHashEmailAmigos < ActiveRecord::Migration
  def change
    create_table :log_hash_email_amigos do |t|
      t.integer :cliente_id
      t.string :rand_hash

      t.timestamps
    end
    add_index :log_hash_email_amigos, :cliente_id
  end
end
