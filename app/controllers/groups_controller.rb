class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, except: [:create, :index]
  load_and_authorize_resource

  def index
    @groups = Group.search(current_user, params[:search_filter])
                   .page(params[:page])
                   .per(10)
    @group = Group.new
  end

  def create
    @group = current_user.owned_groups.create(group_params)
    attach_message @group.persisted?, @group.errors
    redirect_to groups_path('#ModalAddGroup')
  end

  def edit; end

  def update
    attach_message @group.update(group_params), @group.errors
    redirect_to edit_group_path(@group)
  end

  def destroy
    attach_message @group.destroy, @group.errors
    redirect_to groups_path
  end

  def change_members
    attach_message @group.change_students(student_ids), @group.errors
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
