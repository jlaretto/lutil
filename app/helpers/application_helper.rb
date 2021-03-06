module ApplicationHelper

  include ActionView::Helpers::NumberHelper

  def company_context_present?
    current_user.present? && current_user.active_company.present?
  end

  #probably should be refactored!
  def format_name(person)

    if person.middle_name.present?
      middle = "#{person.middle_name[0]}. "
    else
      middle = " "
    end

    "#{person.first_name} #{middle}#{person.last_name}"
  end

  def format_phone(obj)
    number_to_phone(obj.phone, :area_code => true)
  end

  def format_percent(num)
    val =     "%3.2f" % (num * 100.0)

    "#{val}%"
  end

  def format_shares(num)
    number_with_delimiter(Integer(num))
  end

  #TODO: this probably can be fixed
  def jeff_parse_float(val)
    if val.nil?
      Float(0)
    else
      val.to_s.gsub(",", "").to_f
    end
  end
end

