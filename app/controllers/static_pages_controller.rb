class StaticPagesController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_filter :redirect_to_sign_in

  def home

  end

  def about
  end

  def help
  end

  def initial_capitalization
    cumulative_percent = 100
    @balanceID = 0
    unless params[:balance_of_equity].nil?
      @balanceID = Integer(params[:balance_of_equity])
    end

    @people = Company.first.people
    @percentages = {}
    issueShares = Integer(params["issue_shares"] || 0)
    @shares = {}
    @people.each do |person|

        unless @balanceID == person.id
          pct = Integer(params["#{person.id}_percent"] || 0)
          @percentages[person.id] = pct
          @shares[person.id] =  number_with_delimiter(Integer(issueShares * (Float(pct) / 100)))
          cumulative_percent -= pct
        end

    end
    unless @balanceID == 0
      @shares[@balanceID] = Integer(issueShares * (Float(cumulative_percent) / 100))
      @percentages[@balanceID] = cumulative_percent
    end

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

  def redirect_to_sign_in

  end

end
