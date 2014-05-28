class RemoveRefCompraPagseguroFromCliente < ActiveRecord::Migration
  def change
    remove_column :clientes, :ref_compra_pagseguro, :string
  end
end
