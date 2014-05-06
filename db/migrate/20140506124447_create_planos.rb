class CreatePlanos < ActiveRecord::Migration
  def change
    create_table :planos do |t|
      t.string :nome
      t.decimal :preco

      t.timestamps
    end
  end
end
