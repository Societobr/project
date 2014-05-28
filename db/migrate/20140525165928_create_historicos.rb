class CreateHistoricos < ActiveRecord::Migration
  def change
    create_table :historicos do |t|
      t.integer :cliente_id
      t.integer :status_transacao_pag_seguros_id
      t.datetime :data

      t.timestamps
    end
    add_index :historicos, :cliente_id
    add_index :historicos, :status_transacao_pag_seguros_id
  end
end
