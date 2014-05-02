class CreateClientes < ActiveRecord::Migration
  def change
    create_table :clientes do |t|
      t.string :nome
      t.string :sobrenome
      t.string :email
      t.string :cpf
      t.date :nascimento
      t.string :telefone
      t.string :cep
      t.string :estado
      t.string :cidade
      t.string :endereco

      t.timestamps
    end
  end
end
