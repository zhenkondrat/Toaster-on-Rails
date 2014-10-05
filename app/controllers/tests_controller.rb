class TestsController < ApplicationController
  def set_weights

  end

  def create
    test = Test.create!(test_params)
    redirect_to test_path(test.id)
  end

  def show
    @test = Test.find(params[:id])
    @subject_name = Subject.find(@test.subject_id).subject_name
  end

  private

  def test_params
    answer = params.permit(:theme, :subject => [:subject_id])
    [:name => answer[:theme], :subject_id => answer[:subject][:subject_id]]
  end
end
