class CapitalizationRecord < ActiveRecord::Base
  attr_accessible :description, :authorized_amount, :capitalization_table
  belongs_to :capitalization_table
  has_many :equity_plans
  has_many :equity_records
end
