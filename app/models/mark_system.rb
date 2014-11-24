class MarkSystem < ActiveRecord::Base
  has_many :marks, :foreign_key => :mark_system_id, :dependent => :delete_all
end