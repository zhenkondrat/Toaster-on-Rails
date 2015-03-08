namespace :fix do
  desc 'generate fake users'
  task admin_flag: :environment do
    User.where(admin: nil).update_all(admin: false)
  end
end
