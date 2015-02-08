class ResultsController < ApplicationController
  def index
    @results = Results.all.group(:created_at).limit(10)
  end
end
