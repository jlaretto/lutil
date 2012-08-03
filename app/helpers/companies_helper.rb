module CompaniesHelper

  def validateCompanyAccess(companyID)

    arrCompanies = current_user.person.companies
    found = false
    arrCompanies.each do |c|
      if c.id == Integer(companyID)
         found = true
      end
    end

    if found && current_user.active_company_id != Integer(companyID)
      current_user.active_company_id = Integer(companyID)
      current_user.save!

      #saves trigger new keys, so update session
      updateSessionCookie
    end

    return found
  end


end
