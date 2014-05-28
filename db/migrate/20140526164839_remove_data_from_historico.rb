class RemoveDataFromHistorico < ActiveRecord::Migration
  def change
    remove_column :historicos, :data, :string
  end
end
