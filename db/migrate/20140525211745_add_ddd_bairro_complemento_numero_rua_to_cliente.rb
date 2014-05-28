class AddDddBairroComplementoNumeroRuaToCliente < ActiveRecord::Migration
  def change
    add_column :clientes, :ddd, :string
    add_column :clientes, :bairro, :string
    add_column :clientes, :complemento, :string
    add_column :clientes, :numero, :string
    add_column :clientes, :rua, :string
  end
end
