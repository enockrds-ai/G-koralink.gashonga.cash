class Member < ApplicationRecord
  self.table_name = "members"
  belongs_to :user, foreign_key: :user_id, optional: true
  belongs_to :group, foreign_key: :group_id, optional: true
  has_many :savings, foreign_key: :member_id
end
