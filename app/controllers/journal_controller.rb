class JournalController < ApplicationController
  def index
    if params.include? :reg_group
      @action = :reg_group
      @users = User.all.where('admin' => 0)
    elsif params.include? :reg_user # add new user
      @action = :reg_user
      @groups = Group.all
    elsif params.include? :reg_users # reg users in some group

      redirect_to journal_path
    else
      @groups = Group.all
      @users = User.all.where('admin' => 0)
    end
  end

  def reg_group
    Group.create!(:name => params[:group_name])
    redirect_to journal_path
  end

  def reg_user
    User.create!(
      :login => params[:user_login],
      :password => params[:user_password],
      :first_name => params[:user_first_name],
      :last_name => params[:user_last_name],
      :father_name => params[:user_father_name],
      :admin => false
    )
    redirect_to journal_path
  end

end
