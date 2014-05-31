class AddRecorrenciaToEmailExpiracaoPlano < ActiveRecord::Migration
  def change
    add_column :email_expiracao_planos, :recorrencia, :integer
  end
end
