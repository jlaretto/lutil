class EquityRecord < ActiveRecord::Base

  attr_accessible :amount, :equity_type, :capitalization_record, :person, :equity_plan, :proforma_target_amount_type

  belongs_to :capitalization_record
  belongs_to :person
  belongs_to :equity_plan
end
