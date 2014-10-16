class MarkSystem < ActiveRecord::Base
  has_many :marks

  def destroy
    Mark.where(mark_system_id: self.id).delete_all
    super
  end

end