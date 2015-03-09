class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_filter :admin_lock
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
    @users = @group.foreign_users.paginate(page: params[:page])
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

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
