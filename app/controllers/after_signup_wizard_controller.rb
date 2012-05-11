class AfterSignupWizardController < ApplicationController
   include Wicked::Wizard

  before_filter :redirect_if_not_signed_in

  steps :company_details, :your_details, :founder_details

  def show
    case step
      when :company_details
        @company = Company.new
      when :your_details
        @person = Person.new
        @person.email = current_user.email

      when :founder_details
        @people = Company.find(session['company_id']).people

    end
    render_wizard
  end

  def update




    case step
      when :company_details
        @company = Company.new(params[:company])
        #updates the user object with the form, and shows next step if the object saves
        if @company.save
          #create first relation
          current_user.active_company = @company

          #bit of a hack for now
          signUserIn(current_user)

          #advance to next step, as render_wizard with now model renders current step
          skip_step


        end
        render_wizard
    end

  end


end
