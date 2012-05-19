class CapitalizationRecord < ActiveRecord::Base
  attr_accessable :description, :authorized_amount
  belongs_to :capitalization_table
  has_many :equity_plans
end
