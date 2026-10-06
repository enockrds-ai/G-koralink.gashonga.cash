class Saving < ApplicationRecord
  self.table_name = "savings"
  belongs_to :member, foreign_key: :member_id, optional: true
end
