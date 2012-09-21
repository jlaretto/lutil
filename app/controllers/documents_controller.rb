class DocumentsController < ApplicationController
  def new
    @document = Document.new
    @company = Company.find_by_id(params[:company_id])
    @document.company = @company
  end

  def create
    @document = Document.new(params[:document])
    if @document.save
      render "show"
    else
      render "new"
    end
  end

  def show
    @document = Document.find_by_id(params[:id])
    @company = @document.company
  end

  def index
  end
end
