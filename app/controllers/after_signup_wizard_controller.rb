class AfterSignupWizardController < ApplicationController
   include Wicked::Wizard

  before_filter :redirect_if_not_signed_in

  steps :company_details, :your_details, :founder_details, :founder_relationships, :initial_capitalization

  def show
    adjust_step_for_user_state


    case step
      when :company_details
        @company = Company.new

      when :your_details
        @person = Person.new
        @person.email = current_user.email

      when :founder_details
        @person = Person.new

      when :founder_relationships
        @founders = current_user.active_company.people
        buildClassesArrayFromRelationships
        session[:classes] = @classes

      when :initial_capitalization
        cumulative_percent = 100
        @balanceID = 0
        unless params[:balance_of_equity].nil?
          @balanceID = Integer(params[:balance_of_equity])
        end

        @people = current_user.active_company.people
        @percentages = {}
        issueShares = Integer(params["issue_shares"] || 0)
        @shares = {}
        @people.each do |person|

          unless @balanceID == person.id
            pct = Integer(params["#{person.id}_percent"] || 0)
            @percentages[person.id] = pct
            @shares[person.id] =  issueShares * (Float(pct) / 100)
            cumulative_percent -= pct
          end

        end
        unless @balanceID == 0
          @shares[@balanceID] = Integer(issueShares * (Float(cumulative_percent) / 100))
          @percentages[@balanceID] = cumulative_percent
        end
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

      when :your_details, :founder_details
        @person = Person.new(params[:person])
        #updates the user object with the form, and shows next step if the object saves
        if @person.save
          relation = RelationPersonCompany.new
          relation.person = @person
          relation.company = current_user.active_company
          relation.save!

          if step == :your_details
            current_user.person = @person
            #bit of a hack for now - if we are updating our details, save our record
            signUserIn(current_user)
            skip_step
          else
            @person = Person.new
          end
        end
      when  :founder_relationships

        #buildClassesArrayFromRelationships
        #possible security issue here, but for now hack
        @classes = session[:classes]

        if params[:commit].present?
            @errors = []
            @errors.push("You must appoint an incorporater for your company.") if @classes[:incorporater].count == 0
            @errors.push("You must have at least one director..") if @classes[:directors].count == 0
            @errors.push("You must appoint a president.") if @classes[:president].count == 0
            @errors.push("You must appoint a secretary.") if @classes[:secretary].count == 0
            @errors.push("You must appoint a treasurer.") if @classes[:treasurer].count == 0
            if @errors.count == 0
              #save relationships
              company = current_user.active_company

              #incorporater
              RelationPersonCompany.new(person_id: @classes[:incorporater].keys[0].to_i, company_id: company.id, relation_type: "incorporator").save!

              #Directors
              @classes[:directors].keys.each {|id| RelationPersonCompany.new(person_id: id.to_i, company_id: company.id, relation_type: "director").save! }

              #President
              RelationPersonCompany.new(person_id: @classes[:president].keys[0].to_i, company_id: company.id, relation_type: "officer", relation_detail: "president").save!
              RelationPersonCompany.new(person_id: @classes[:treasurer].keys[0].to_i, company_id: company.id, relation_type: "officer", relation_detail: "treasurer").save!
              RelationPersonCompany.new(person_id: @classes[:secretary].keys[0].to_i, company_id: company.id, relation_type: "officer", relation_detail: "secretary").save!

              skip_step

            else
              flash[:error] = @errors.join(" ")

            end
        else
          @command = params[:update].split('|')
          case @command[1]
            when "incorporater"
              @classes[:incorporater] = {@command[0].to_i => true}
            when "directors"
              if @classes[:directors][@command[0].to_i].nil?
                 @classes[:directors][@command[0].to_i] = true;
              else
                @classes[:directors].delete(@command[0].to_i)
              end
            when "president"
              if @classes[:president][@command[0].to_i].nil?
                @classes[:president][@command[0].to_i] = true;
              else
                @classes[:president].delete(@command[0].to_i)
              end
            when "secretary"
              if @classes[:secretary][@command[0].to_i].nil?
                @classes[:secretary][@command[0].to_i] = true;
              else
                @classes[:secretary].delete(@command[0].to_i)
              end
            when "treasurer"
              if @classes[:treasurer][@command[0].to_i].nil?
                @classes[:treasurer][@command[0].to_i] = true;
              else
                @classes[:treasurer].delete(@command[0].to_i)
              end

            else
                                           #           @classes = {incorporater: {}}
   #
          end
    #
          session[:classes] = @classes
          end

        @founders = current_user.active_company.people
    end
    render_wizard
  end




private
  def adjust_step_for_user_state
    # push past company step
    if step == :company_details && current_user.active_company.present?
      skip_step
    end

    # push past person step
    if step == :your_details && current_user.person.present?
      skip_step
    end
  end

  def buildClassesArrayFromRelationships
    @classes = {incorporater: {}, directors: {}, secretary: {}, treasurer: {}, president: {}}
=begin    current_user.active_company.relation_person_companies.each do |rel|
      case rel.relation_type
        when "officer"
          @classes[:director]["#{rel.person_id}|#{rel.relation_detail}"] = true
             # @classes[:director]["#{rel.person_id}|director"] = true
          end
        when "director"
          @classes[:director]["#{rel.person_id}|director"] = true

        when "incorporater"
          @classes[:incorporater]["#{rel.person_id}|incorporater"] = true

      end
      #relation_detail
    end
=end
   end
  def unpackHash
#    @arrHighLevel = params[:classes].split(',')
 #   @classes = {}
  #  @arrHighLevel.each do |i|
   #   @entry =
   # end
  end

end
