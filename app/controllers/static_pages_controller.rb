class StaticPagesController < ApplicationController
 #should be inlucded thorugh app helper
 # include ActionView::Helpers::NumberHelper

  def home

  end

  def about
  end

  def help
  end

  def initial_capitalization


  end


  def wizard
    if params[:step].nil?
      @step = "Step 1"
      @company = Company.new
    else
      if params["Commit"] == "Next"
        @step = Steps[Steps.index(params[:step])+1]
      else
        @step = Steps[Steps.index(params[:step])-1]
      end
    end
  end

  private

    Steps = ["Step 1", "Step 2", "Step 3"]



end
