class CreateEmailCpfJaCadastrados < ActiveRecord::Migration
  def change
    create_table :email_cpf_ja_cadastrados do |t|
      t.string :assunto
      t.string :body

      t.timestamps
    end
  end
end
