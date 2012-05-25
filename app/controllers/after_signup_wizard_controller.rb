class AfterSignupWizardController < ApplicationController
   include Wicked::Wizard
   include AfterSignupWizardHelper
   include ApplicationHelper

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
        @classes = {incorporater: {}, directors: {}, secretary: {}, treasurer: {}, president: {}}
        session[:classes] = @classes

      when :initial_capitalization
        cumulative_percent = Float(100)
        @authorized_shares = Float(15000000)
        @issued_shares = Float(10000000)
        @buttons = [" active", "", ""]
        @old_balance_person_id = -1
        @pool_option = :founder
        @pool_percent = Float(0)

        initial_capitalizaton_set_values


    end
    render_wizard
  end

  def update

    adjust_step_for_user_state


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

      when :initial_capitalization
        @authorized_shares = jeff_parse_float(params[:authorized_shares])
        @issued_shares = jeff_parse_float(params[:issued_shares])
        @buttons = ["", "", ""]
        @buttons[Integer(params[:button_index])] = " active"
        @pool_percent = jeff_parse_float(params[:pool_percent])

        case Integer(params[:button_index])
          when 0
            @pool_option = :founder
          when 1
            @pool_option = :founder_and_pool
          else
          @pool_option = :none
        end



        @balance_person_id = -1
        @old_balance_person_id = Integer(params[:old_balance_person_id])

        initial_capitalizaton_set_values

        if params[:commit] == "Save"

          ActiveRecord::Base.transaction do


             #save transaction and redirect
            #1 Create cap table
            capTable = CapitalizationTable.new(description: "Initial Capitalization", actual: true, company: current_user.active_company)
            capTable.save!

            #2 Create common stock cap record
            capRecord = CapitalizationRecord.new(description: "Common Stock", authorized_amount: @authorized_shares, capitalization_table: capTable)
            capRecord.save!

            #3 Create plan (if applicable) - attache to common stock cap record
            equityPlan = EquityPlan.new(description: "2012 Equity Incentive Plan", authorized_amount: @pool_shares, capitalization_record: capRecord )
            equityPlan.save!

            #4 Iterate people and create equity records
            current_user.active_company.people.each do |founder|
              #todo create constnats
               EquityRecord.new(amount: @shares[founder.id][:shares], equity_type: "Restricted Stock", capitalization_record: capRecord).save!
            end

            flash[:success] = "Wizard completed!"
            redirect_path = root_path
          end

          #redirect to root path



        end

    end

    if redirect_path.nil?
      render_wizard
    else
      redirect_to redirect_path
    end
  end




private
  def adjust_step_for_user_state

    if current_user.active_company.nil?
      jump_to :company_details
    end

    # push past company step
    if step == :company_details && current_user.active_company.present?
      skip_step
    end

    # push past person step
    if step == :your_details && current_user.person.present?
      skip_step
    end



  end




  def initial_capitalizaton_set_values

    cumulative_percent = Float(100)
    @balance_person_id = -1

    if params[:balance_of_equity].nil?
      @balance_person_id = @old_balance_person_id
    else
      @balance_person_id = Integer(params[:balance_of_equity])
    end

    @people = current_user.active_company.people

    @percentages = {}
    @shares = {}

    #set the denominaters
    if @pool_option == :founder
      #if we are in the option where pool and founder group, deduct the pool
      cumulative_percent -= @pool_percent  unless @pool_option == :founder_and_pool
      issued_shares = @issued_shares - (@issued_shares * @pool_percent / 100.0)
      fully_diluted_shares = @issued_shares
      @pool_shares = ((@issued_shares * @pool_percent)/100.0).to_i
    elsif @pool_option == :none
      issued_shares = fully_diluted_shares = @issued_shares
    elsif
      issued_shares = @issued_shares
      fully_diluted_shares = @issued_shares / (1.0 - (@pool_percent/100.0))
      @pool_shares = Integer(issued_shares - fully_diluted_shares)
    end



    # toggle throug all people and calibrate percentages
    @people.each do |person|
      unless @balance_person_id == person.id
        if(@old_balance_person_id == person.id)
          # this person previously had the balance, but no longer
          pct = 0.0
        else
          # pluck percentage from form
          pct = jeff_parse_float(params["#{person.id}_percent"] || 0)
        end
        @percentages[person.id] = pct

        #shares
        shares =  Integer(@issued_shares * (pct / Float(100)))
        @shares[person.id] = { shares: shares,
                               percent: shares / issued_shares * 100,
                               percent_fd: shares / fully_diluted_shares * 100 }
        cumulative_percent -= pct
      end
    end


    if cumulative_percent < 0
      flash[:error] = "You have allocated more than 100% - please reduce the allocations so that the sum equals 100%"
      cumulative_percent = 0
      @allow_to_save = false
    else
      flash.clear
      @allow_to_save = true
    end


    #if a person is designated to receive the balance of equity, assign the balance
    unless @balance_person_id == -1
      shares = Integer(@issued_shares * (cumulative_percent / 100))
      @shares[@balance_person_id] = { shares: shares,
                             percent: shares/issued_shares*100,
                             percent_fd: shares/fully_diluted_shares*100 }

    end


  end
end
