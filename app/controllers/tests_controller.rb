class TestsController < ApplicationController

  def save_answer
    answers = session[:answers] || []
    case params[:question_type]
    when '1'
      answers.push [params[:question_id],
                    params[:question_type],
                    params[:answer1]
                   ]
    when '2'
      answers.push [params[:question_id],
                    params[:question_type],
                    params[:standard]
                   ]
    else
      answer1 = {}; answer2 = {}
      params.each_key { |key|
        answer1[key[3..-1]] = params[key] if key.index('ucl') # key[3..-1] : ucl100 => 100
        answer2[key[3..-1]] = params[key] if key.index('ucr') # key[3..-1] : ucr99 => 99
      }
      answers.push [params[:question_id],
                    params[:question_type],
                    [answer1, answer2]
                   ]
    end
    session[:answers] = answers
  end

  def del_group_from_list
    group_id = params[:gid]
    test_id = params[:tid]
    TestGroup.where(:group_id => group_id, :test_id => test_id).delete_all
    redirect_to edit_test_path(test_id)
  end

  def reg_group
    test = Test.find(params[:test_id])
    groups = params[:groups_check]
    groups.each{ |id|
      test.reg_group id
    }
    redirect_to edit_test_path(test.id)
  end

  def results
    @results = []
    test_id = params[:test]
    group_id = params[:group]
    @group_name = Group.find(params[:group]).name
    @test_name = Test.find(params[:test]).name
    users = User.joins('INNER JOIN user_groups ON user_groups.user_id = users.id').where('user_groups.group_id = '+group_id.to_s)
    users.each do |user|
      result = user.result(test_id)
      @results.push [user.login, user.get_fio, result[0], result[1]]
    end
  end

  def create
    test = Test.create!(test_params)
    redirect_to edit_test_path(test.id)
  end

  def edit
    @test = Test.find(params[:id])
    @subjects = Subject.all
    @questions = Question.where(:test_id => @test.id)
    @groups = Group.all
    @test_groups = Group.joins('INNER JOIN test_groups ON test_groups.group_id = groups.id
                                INNER JOIN tests ON test_groups.test_id = tests.id')
                        .where("tests.id = #{@test.id}")
  end

  def update
    test = Test.find(params[:id])
    test.update!(test_params)
    redirect_to edit_test_path test.id
  end

  def show
    if !session[:local]      # if I just want start pass test
      test = Test.find(params[:id])
      session[:test_id] = test.id
      session[:questions] = test.questions
      session[:local] = 0
      session[:answers] = nil
      session[:time] = test.question_time
    else
      save_answer
    end

    @local = session[:local]
    if session[:local] != session[:questions].count
      @question = Question.find(session[:questions][@local])
      session[:local] = @local+1
    else
      redirect_to root_path
    end
  end

  def destroy
    Test.find(params[:id]).destroy
    flash[:notice] = 'Тест успішно видалено'
    redirect_to root_path
  end

  private

  def test_params
    params.require(:test)
          .permit(:name,
                  :weight1,
                  :weight2,
                  :weight3,
                  :subject_id,
                  :questions_count,
                  :question_time,
                  :mark_system
    )
  end

end
