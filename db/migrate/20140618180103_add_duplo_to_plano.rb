class AddDuploToPlano < ActiveRecord::Migration
  def change
    add_column :planos, :duplo, :boolean
  end
end
