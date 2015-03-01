class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_filter :admin_lock
  before_action :set_group, except: [:create, :index]

  def index
    @groups = Group.paginate(page: params[:page])
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
    @users = @group.users.paginate(page: params[:page])
  end

  def update
    if @group.update subject_params
      flash[:notice] = 'Group is successfully updated'
    else
      flash[:error] = 'Something went wrong'
    end
    redirect_to groups_path
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
