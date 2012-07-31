class CapitalizationTablesController < ApplicationController
  def create
     render "show"
  end

  def show
    @proforma = true
    @new_equity_record = EquityRecord.new

    @company = Company.find_by_id(params[:company_id])
    @capTable = CapitalizationTable.find_by_id(params[:id])
    @capitalization_records = @company.capitalization_records
    @equityPlans = @company.equity_plans

    @outstanding_shares = 0
    @fully_diluted_shares = 0

    @capitalization_records.each do |capRec|
      capRec.equity_records.each do |e|
        @outstanding_shares += e.amount

        @fully_diluted_shares += e.amount if e.equity_plan.nil?

      end
      capRec.equity_plans.each do |plan|

        @fully_diluted_shares += plan.authorized_amount
      end
    end

    #process proformas




  end

  def index
    @company = Company.find_by_id(params[:company_id])
    @cap_tables = @company.capitalization_tables
    if @cap_tables.count == 1
      redirect_to company_capitalization_table_path(@company, @cap_tables.first)
    end
  end
end
