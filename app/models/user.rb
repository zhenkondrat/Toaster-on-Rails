class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable
  has_many :groups, through: :user_groups

  def email_required?
    false
  end

  def registrations
    groups_id = ""
    groups = UserGroup.where('user_id' => self.id).select(:group_id)
    groups.each{ |g|
      groups_id += g.group_id.to_s+", "
    }
    groups_id.empty? ? nil : Group.where('id IN ('+groups_id.chop.chop+')')
  end

  def tests
    Test.joins('INNER JOIN test_groups ON test_groups.test_id = tests.id
                INNER JOIN user_groups ON test_groups.group_id = user_groups.group_id
                INNER JOIN users ON users.id = '+self.id.to_s)
              .select('tests.id, tests.name')
  end

  def results count = nil
    results = if count
                Result.where(user_id: self.id).order(created_at: :desc).limit(count)
              else
                Result.where(user_id: self.id).order(created_at: :desc)
              end
    out = []

    results.each do |result|
      test = Test.find(result.test_id)
      out.push [test.get_subject_name, test.name, result.mark_presentation, result.created_at]
    end

    out
  end
end

