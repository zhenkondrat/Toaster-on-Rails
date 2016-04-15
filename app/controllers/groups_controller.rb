class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, except: [:create, :index]
  load_and_authorize_resource

  def index
    @groups = Group.search(current_user, params[:search_filter]).page(params[:page]).per(10)
    @group = Group.new
  end

  def create
    @group = current_user.owned_groups.create(group_params)
    if @group.persisted?
      flash[:notice] = 'Group is successfully created'
    else
      flash[:error] = @group.errors.join(', ')
    end
    redirect_to groups_path('#ModalAddGroup')
  end

  def edit; end

  def update
    if @group.update(group_params)
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
    @group.change_students(student_ids)
    flash[:notice] = 'Users are successfully joined to group'
    redirect_to edit_group_path(@group)
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
    @group = current_user.owned_groups.find(params[:id])
  end

  def student_ids
    params.require(:group).permit(users: [])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
