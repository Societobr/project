class AddRegistroToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :registro, :string
  end
end
