class StatusUpdate < ActiveRecord::Base
  attr_accessible   :company, :user, :description
  belongs_to :company
  belongs_to :user

end
