class DocumentsController < ApplicationController
  def new
    @document = Document.create(company_id: params[:company_id])
    @company = Company.find_by_id(params[:company_id])
  end

  def create
  end

  def show
    @document = Document.find_by_id(params[:id])
    @company = @document.company
  end

  def index
  end
end
