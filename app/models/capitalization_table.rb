class CapitalizationTable < ActiveRecord::Base
  attr_accessible :description, :actual, :company

  has_many :capitalization_records
  belongs_to :company
end
