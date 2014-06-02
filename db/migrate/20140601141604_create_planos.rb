class CreatePlanos < ActiveRecord::Migration
  def change
    create_table :planos do |t|
      t.string :nome
      t.integer :vigencia
      t.decimal :preco
      t.integer :codigo

      t.timestamps
    end
  end
end
