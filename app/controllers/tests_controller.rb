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
    @questions = Question.where(:test_id => @test.id)
    @groups = Group.all
    @test_groups = Group.joins('INNER JOIN test_groups ON test_groups.group_id = groups.id
                                INNER JOIN tests ON test_groups.test_id = tests.id')
                        .where("tests.id = #{@test.id}")
  end

  def del_group_from_list
    group_id = params[:gid]
    test_id = params[:tid]
    TestGroup.where(:group_id => group_id, :test_id => test_id).delete_all
    redirect_to test_path(test_id)
  end

  def reg_group
    test = Test.find(params[:test_id])
    groups = params[:groups_check]
    groups.each{ |id|
      test.reg_group id
    }
    redirect_to test_path(test.id)
  end

  private

  def test_params
    answer = params.permit(:theme, :subject => [:subject_id])
    [:name => answer[:theme], :subject_id => answer[:subject][:subject_id]]
  end
end
