module AfterSignupWizardHelper

  def parse_int(val)
    val.to_s.gsub(",", "").to_i
  end
end
