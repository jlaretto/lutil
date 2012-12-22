class DocumentsController < ApplicationController
  before_filter { |cntr|  redirect_to root_path if !validateCompanyAccess(params[:company_id])}

  def new
    @document = Document.new
    @company = Company.find_by_id(params[:company_id])
    @document.company = @company
    @document.document_type = params[:docType]
  end

  def create
    @document = Document.new(params[:document])
    @company = Company.find_by_id(params[:company_id])
    @document.company = @company
    #save the file into our data director
    #@document.saveFile(@document.aws_key)


    if @document.save
      redirect_to company_documents_path
    else
      render "new"
    end
  end

  def show
    @document = Document.find_by_id(params[:id])
    @company = @document.company
  end

  def index
    @company = Company.find_by_id(params[:company_id])

  end


end
