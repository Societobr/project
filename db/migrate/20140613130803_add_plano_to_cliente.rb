class AddPlanoToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :plano_id, :integer
    add_index :clientes, :plano_id
  end
end
