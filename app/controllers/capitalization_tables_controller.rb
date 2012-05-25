class CapitalizationTablesController < ApplicationController
  def create
  end

  def show
    @company = Company.find_by_id(params[:company_id])
    @capitalization_records = @company.capitalization_records
  end

  def index
    @company = Company.find_by_id(params[:company_id])
    @cap_tables = @company.capitalization_tables
    if @cap_tables.count == 1
      redirect_to company_capitalization_table_path(@company, @cap_tables.first)
    end
  end
end
