class AddRefCompraPagSeguroToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :ref_compra_pagseguro, :string
  end
end
