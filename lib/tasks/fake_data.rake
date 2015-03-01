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
end