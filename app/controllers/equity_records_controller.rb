class EquityRecordsController < ApplicationController
  before_filter :redirect_if_not_signed_in
  before_filter { |cntr|  redirect_to root_path if !validateCompanyAccess(params[:company_id])}

  def create

    @company = Company.find_by_id(params[:company_id])

    @new_equity_record = EquityRecord.new(params[:equity_record])
    @new_equity_record.company = @company

    if @new_equity_record.save
      @new_equity_record = EquityRecord.new
    end

    load_cap_table

    render "index"

  end

  def index

    @company = Company.find_by_id(params[:company_id])
    @new_equity_record = EquityRecord.new

    load_cap_table

  end

  def destroy
    record = EquityRecord.find_by_id(params[:id])
    record.delete
    redirect_to company_equity_records_path(params[:company_id])
  end


  def load_cap_table

    #@capTable = CapitalizationTable.find_by_id(params[:id])

    @capitalization_records = @company.capitalization_records
    @equityPlans = @company.equity_plans

    @outstanding_shares = 0
    @fully_diluted_shares = 0

    @pf_pct_issued = 0
    @pf_pct_fd = 0
    @pf_issued_recs = Array.new
    @pf_fd_recs = Array.new

    @capitalization_records.each do |capRec|

      capRec.equity_records.each do |e|
        case e.proforma_target_amount_type
          when Constants::OWNERSHIP_ACTUAL, Constants::OWNERSHIP_AMOUNT
            @outstanding_shares += e.amount
            @fully_diluted_shares += e.amount if e.equity_plan.nil?
          when Constants::OWNERSHIP_ISSUED
            @pf_pct_issued += e.amount
            @pf_issued_recs.append(e)
          when Constants::OWNERSHIP_FULLYDILUTED
            @pf_pct_fd += e.amount
            @pf_fd_recs.append(e)

        end

      #calculate the issued and outstanding amounts
      total_issued_shares = @outstanding_shares / (1.0 - (@pf_pct_issued / 100))
      @pf_issued_recs.each {|rec| rec.amount = @outstanding_shares * rec.amount / 100}




      end

      capRec.equity_plans.each do |plan|
        @fully_diluted_shares += plan.authorized_amount
      end

      #calculate the FD amounts
      @pf_fd_recs.each {|rec| rec.amount = @fully_diluted_shares * rec.amount / 100}

    end




  @proforma = true


  end


end
