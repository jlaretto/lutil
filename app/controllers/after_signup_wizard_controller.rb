class AfterSignupWizardController < Wicked::WizardController
  before_filter :redirect_if_not_signed_in

  steps :company_details, :founder_details

  def show
    case step
      when :company_details
        @company = Company.new
      when :founder_details
      else
    end
    render_wizard
  end

  def update


    case step
      when :company_details
        @company = Company.new(params[:company])
        #updates the user object with the form, and shows next step if the object saves
        render_wizard @company
      else
        render_wizard
    end

   end


end
