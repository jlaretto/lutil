class EquityPlan < ActiveRecord::Base
  attr_accessible :description, :authorized_amount, :capitalization_record, :company, :company_id

  belongs_to :capitalization_record
  belongs_to :person

  belongs_to :company

  has_many :equity_records

  def available_shares
    amount = authorized_amount
    equity_records.each {|rec| amount -= rec.amount}
    return amount
  end

end
