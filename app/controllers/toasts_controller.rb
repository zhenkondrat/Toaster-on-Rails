class ToastsController < ApplicationController

  def del_group_from_list
    group_id = params[:gid]
    toast_id = params[:tid]

    ToastGroup.where(
      :group_id => group_id,
      :toast_id => toast_id
    ).delete_all

    redirect_to edit_toast_path(toast_id)
  end

  def reg_group
    toast = Toast.find(params[:toast_id])
    groups = params[:groups_check]

    groups.each{ |id|
      toast.gro
    }

    redirect_to edit_toast_path(toast.id)
  end

  def results
    @results = []
    toast_id = params[:toast]
    group_id = params[:group]
    @group_name = Group.find(params[:group]).name
    @toast_name = Toast.find(params[:toast]).name
    users = User.joins('INNER JOIN user_groups ON user_groups.user_id = users.id').where('user_groups.group_id = '+group_id.to_s)
    users.each do |user|
      result = user.result(toast_id)
      @results.push [user.login, user.get_fio, result[0], result[1]]
    end
  end

  def create
    toast = Toast.create!(toast_params)
    redirect_to edit_toast_path(toast.id)
  end

  def edit
    @toast = Toast.find(params[:id])
    @subjects = Subject.all
    @questions = Question.where(:toast_id => @toast.id)
    @groups = Group.all
    @toast_groups = Group.joins('INNER JOIN toast_groups ON toast_groups.group_id = groups.id
                                INNER JOIN toasts ON toast_groups.toast_id = toasts.id')
                        .where("toasts.id = #{@toast.id}")
  end

  def update
    toast = Toast.find(params[:id])
    toast.update!(toast_params)
    redirect_to edit_toast_path toast.id
  end

  def show
    if !session[:pass_toast]      # if I just want start pass toast
      toast = Toast.find(params[:id])
      session[:toast_id] = toast.id
      session[:questions] = toast.questions
      session[:local] = 0
      session[:answers] = nil
      session[:time] = toast.question_time
      session[:pass_toast] = true
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
    Toast.find(params[:id]).destroy
    flash[:notice] = 'Тест успішно видалено'
    redirect_to root_path
  end

  private

  def save_answer
    answers = session[:answers] || []
    case params[:question_type]
      when '1'
        answers.push [
          params[:question_id],
          params[:question_type],
          params[:answer1]
        ]
      when '2'
        answers.push [
          params[:question_id],
          params[:question_type],
          params[:standard]
        ]
      else
        answer1 = {}; answer2 = {}
        params.each_key { |key|
          answer1[key[3..-1]] = params[key] if key.index('ucl') # key[3..-1] : ucl100 => 100
          answer2[key[3..-1]] = params[key] if key.index('ucr') # key[3..-1] : ucr99 => 99
        }
        answers.push [
          params[:question_id],
          params[:question_type],
          [answer1, answer2]
        ]
    end
    session[:answers] = answers
  end

  def toast_params
    params.require(:toast)
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
