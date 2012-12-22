class ChangeLog < ActiveRecord::Base
  attr_accessible :objid, :objtype, :objjson, :user_id, :company_id,  :description

end
