class ResultsController < ApplicationController
  def index
    @results = Results.group(:created_at).page(params[:page]).per(30)
  end
end
