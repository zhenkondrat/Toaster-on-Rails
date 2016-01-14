class GroupsController < ApplicationController
  before_action :set_group, except: [:create, :index]

  def index
    @groups = Group.all
    @groups = @groups.where("name LIKE '%#{params[:search_filter]}%'") if params[:search_filter].present?
    @groups = @groups.page(params[:page]).per(10)
    @group = Group.new
  end

  def create
    if Group.create group_params
      flash[:notice] = 'Group is successfully created'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to groups_path
  end

  def edit
    @group_users = @group.users
    @users = @group.foreign_users.page(params[:page]).per(10)
  end

  def update
    if @group.update group_params
      flash[:notice] = 'Group is successfully updated'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to edit_group_path(@group)
  end

  def delete
    if @group.destroy
      flash[:notice] = 'Group is successfully deleted'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to groups_path
  end

  def join_group
    params[:users].each{ |user_id| @group.users << User.find(user_id) }
    flash[:notice] = 'Users are successfully joined to group'
    render js: "window.location = '#{edit_group_path(@group)}'"
  end

  def leave_group
    if @group.users.delete(params[:user])
      flash[:notice] = 'User is successfully expelled from group'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to edit_group_path(@group)
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
