class AfterSignupWizardController < ApplicationController
  before_filter :redirect_if_not_signed_in
  include Wicked::Wizard

  steps :company_details, :founder_details, :initial_capitalization

  def show
    @company = Company.new
    render_wizard

  end



end
