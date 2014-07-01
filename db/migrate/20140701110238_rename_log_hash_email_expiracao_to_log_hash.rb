class RenameLogHashEmailExpiracaoToLogHash < ActiveRecord::Migration
  def change
  	rename_table :log_hash_email_expiracaos, :log_hashes
  end
end
