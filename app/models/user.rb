class User < ApplicationRecord
  self.table_name = "users"
  has_one :member, foreign_key: :user_id

  def password_digest
    row = UserPassword.find_by(user_id: id)
    row&.password_hash
  end
end
