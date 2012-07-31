class CapitalizationRecord < ActiveRecord::Base
  attr_accessible :description, :authorized_amount, :capitalization_table, :company, :company_id
  belongs_to :company
  has_many :equity_plans
  has_many :equity_records
end
