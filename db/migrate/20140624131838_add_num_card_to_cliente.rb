class AddNumCardToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :num_cartao, :string
  end
end
