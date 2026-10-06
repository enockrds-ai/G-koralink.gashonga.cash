class User < ApplicationRecord
  self.table_name = "users"
  def password_digest
    UserPassword.where(user_id: id).pick(:password_hash)
  end
end
