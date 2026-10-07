class Transaction < ApplicationRecord
  self.table_name = "transactions"
  belongs_to :member, foreign_key: :member_id, optional: true
end
