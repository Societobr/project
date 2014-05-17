class CreateAtividades < ActiveRecord::Migration
  def change
    create_table :atividades do |t|
      t.integer :user_id
      t.integer :cliente_id
      t.decimal :preco_total
      t.decimal :valor_desconto

      t.timestamps
    end
    add_index :atividades, :user_id
    add_index :atividades, :cliente_id
  end
end
