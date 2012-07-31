class CapitalizationTable < ActiveRecord::Base
  attr_accessible :description, :actual, :company

  has_many :capitalization_records
  has_many :equity_records
  has_many :equity_plans, through: :capitalization_records
  belongs_to :company
end
