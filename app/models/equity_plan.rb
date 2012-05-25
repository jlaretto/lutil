class EquityPlan < ActiveRecord::Base
  attr_accessible :description, :authorized_amount, :capitalization_record

  belongs_to :capitalization_record
  belongs_to :person

end
