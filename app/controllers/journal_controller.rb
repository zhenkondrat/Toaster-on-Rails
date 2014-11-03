class JournalController < ApplicationController
  def index
    if params.include? :reg_group
      @action = :reg_group
      @users = User.all
    elsif params.include? :reg_user # add new user
      @action = :reg_user
      @groups = Group.all
    elsif params.include? :add_group # add group(save)
      reg_group
    elsif params.include? :rm_users # remove users
      remove_users
    elsif params.include? :rm_groups # remove users
      remove_group
    elsif params.include? :reg_users_in_group # reg users in some groups
      reg_users_in_group
    else
      if (params.include? :search_group) || (params.include? :search_user)
        @groups = Group.where("name LIKE '"+params[:group_name]+"%'")
        @users = User.where("login LIKE '"+params[:user_name]+"%'")
      else
        @groups = Group.all
        @users = User.all
      end
    end
  end

  def save_user_info
    user = User.find(params[:save_user])
    user.login = params[:user_login]
    user.first_name = params[:user_first_name]
    user.last_name = params[:user_last_name]
    user.father_name = params[:user_father_name]
    user.save!
    redirect_to user_info_path(user.id)
  end

  def delete_users_group
    begin
      UserGroup.find_by(:user_id => params[:user_id], :group_id => params[:group_id]).destroy!
    rescue
      flash[:error] = "Полегше :)"
    end
    redirect_to user_info_path(params[:user_id])
  end

  def user_info
    @user = User.find(params[:id])
    @action = :user_info
    @groups = Group.all
    @user_groups = @user.registrations
  end

  private

  def reg_group
    Group.create!(:name => params[:group_name])
    flash[:notice] = 'Група успішно створена'
    redirect_to journal_path
  end

  def remove_group
    groups = params[:groups_check]
    if !groups.empty?
      groups.each{ |id|
        Group.find(id).destroy!
        registrations = UserGroup.where(:group_id => id)
        registrations.each{ |e| e.destroy! } if registrations
      }
      flash[:notice] = 'Групи успішно видалені'
    else
      flash[:error] = 'Ви не обрали жодну групу'
    end
    redirect_to journal_path
  end

  def remove_users
    users = params[:users_check]
    if !users.empty?
      users.each{ |id|
        User.find(id).destroy!
        registrations = UserGroup.where(:user_id => id)
        registrations.each{ |e| e.destroy! } if registrations
      }
      flash[:notice] = 'Користувачі успішно видалені'
    else
      flash[:error] = 'Ви не обрали жодного користувача'
    end
    redirect_to journal_path
  end

  def reg_users_in_group
    users = params[:users_check]
    groups = params[:groups_check]
    groups.each{ |group_id|
      users.each { |user_id|
        unless User.find(user_id).admin? || UserGroup.find_by(:user_id => user_id, :group_id => group_id)
          UserGroup.create!(:user_id => user_id, :group_id => group_id)
        end
      }
    }
    flash[:notice] = 'Користувачі успішно зареєстровані'
    redirect_to journal_path
  end

end
