class RemoveSobrenomeEnderecoFromCliente < ActiveRecord::Migration
  def change
    remove_column :clientes, :sobrenome, :string
    remove_column :clientes, :endereco, :string
  end
end
