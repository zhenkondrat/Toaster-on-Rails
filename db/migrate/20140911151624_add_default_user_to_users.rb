class AddDefaultUserToUsers < ActiveRecord::Migration
  def up
    if User.all[0].nil?
      User.create!(:login => 'admin', :password => 'admin', :admin => true)
    end
  end

  def down
    User.find(1).destroy!
  end
end
