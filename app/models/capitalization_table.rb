class CapitalizationTable < ActiveRecord::Base
  attr_accessable :description, :actual

  has_many :capitalization_records
end
