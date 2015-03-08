require 'faker'

namespace :fake_data do
  desc 'generate fake subjects'
  task subjects: :environment do
    10.times{ Subject.create(name: Faker::Lorem.word.capitalize) }
  end

  desc 'generate fake groups'
  task groups: :environment do
    10.times{ Group.create(name: Faker::Lorem.word.capitalize) }
  end

  desc 'generate fake users'
  task users: :environment do
    10.times do
      User.create({login: Faker::Internet.user_name,
                  password: 'qwe123',
                  last_name: Faker::Name.last_name,
                  first_name: Faker::Name.first_name,
                  father_name: Faker::Name.first_name
      })
    end
  end
end
