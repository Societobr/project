class CreateEmailCadastroEfetuados < ActiveRecord::Migration
  def change
    create_table :email_cadastro_efetuados do |t|
      t.string :assunto
      t.string :body

      t.timestamps
    end
  end
end
