class Subject < ActiveRecord::Base
  has_many :test, :foreign_key => :subject_id, :dependent => :delete_all
end
