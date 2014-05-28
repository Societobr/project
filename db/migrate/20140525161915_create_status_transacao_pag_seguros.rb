class CreateStatusTransacaoPagSeguros < ActiveRecord::Migration
  def change
    create_table :status_transacao_pag_seguros do |t|
      t.integer :code
      t.string :description

      t.timestamps
    end
  end
end
