class ResultsController < ApplicationController
  def index
    @results = Results.group(:created_at).paginate(page: params[:page])
  end
end
