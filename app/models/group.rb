class Group < ApplicationRecord
  self.table_name="groups"
  has_many :members,foreign_key: :group_id
end
