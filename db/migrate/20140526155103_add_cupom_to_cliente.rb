class AddCupomToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :cupom, :string
  end
end
