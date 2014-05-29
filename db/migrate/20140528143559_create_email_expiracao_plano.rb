class CreateEmailExpiracaoPlano < ActiveRecord::Migration
  def change
    create_table :email_expiracao_planos do |t|
      t.string :assunto
      t.integer :antec_envio
      t.text :body
    end
  end
end
