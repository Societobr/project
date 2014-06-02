class RenameStatusTransacaoPagSeguroIdColumn < ActiveRecord::Migration
  def change
    rename_column :historicos, :status_transacao_pag_seguros_id, :status_transacao_pag_seguro_id
  end
end
