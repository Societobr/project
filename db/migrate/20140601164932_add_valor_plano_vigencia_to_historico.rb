class AddValorPlanoVigenciaToHistorico < ActiveRecord::Migration
  def change
    add_column :historicos, :valor, :decimal
    add_column :historicos, :plano_id, :integer
    add_index :historicos, :plano_id
    add_column :historicos, :vigencia, :date
  end
end
