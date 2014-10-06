class TestGroup < ActiveRecord::Base
  belongs_to :group
  belongs_to :test
end
