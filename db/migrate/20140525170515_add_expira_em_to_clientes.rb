class AddExpiraEmToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :expira_em, :date
  end
end
