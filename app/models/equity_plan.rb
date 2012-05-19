class EquityPlan < ActiveRecord::Base
  attr_accessable :description, :authorized_amount

  belongs_to :capitalization_record

end
