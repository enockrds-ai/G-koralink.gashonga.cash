class UserPassword < ApplicationRecord
  self.table_name = "userPasswords"
  belongs_to :user, foreign_key: :user_id, optional: true
end
