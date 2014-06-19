class AddClienteToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :cliente_id, :integer
    add_index :clientes, :cliente_id
  end
end
