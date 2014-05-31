class AddAceiteToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :aceite, :boolean
  end
end
