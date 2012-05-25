class EquityRecord < ActiveRecord::Base

  attr_accessible :amount, :equity_type, :capitalization_record

  belongs_to :capitalization_record
end
