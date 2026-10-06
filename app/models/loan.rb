class Loan < ApplicationRecord
  self.table_name="loans"
  belongs_to :member,foreign_key: :member_id,optional:true
end
