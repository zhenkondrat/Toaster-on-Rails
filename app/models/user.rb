class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable, :validatable
  has_many :user_groups, :foreign_key => :user_id, :dependent => :delete_all
  has_many :results, :foreign_key => :user_id, :dependent => :delete_all
  attr_accessor :token
  validates :login, :uniqueness => true

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def registrations # List the groups where user is already joined
    groups_id = ''
    groups = UserGroup.where('user_id' => self.id).select(:group_id)
    groups.each{ |g|
      groups_id += g.group_id.to_s+', '
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
      out.push [test.get_subject_name, test.name, result.mark_presentation, result.created_at.to_formatted_s(:db)]
    end

    out
  end

  def result test_id
    results = Result.where(user_id: self.id, test_id: test_id).order(created_at: :desc)
    out = ''
    results.each do |t|
      out += t.mark_presentation + ', '
    end
    out.chop!; out.chop!
    if results != []
      [out, results[0].created_at.to_formatted_s(:db)]
    else
      [out, '-']
    end
  end

  def self.results count = nil
    results = if count
                Result.all.order(created_at: :desc).limit(count)
              else
                Result.all.order(created_at: :desc)
              end
    out = []

    results.each do |result|
      test = Test.find(result.test_id)
      out.push [test.get_subject_name, test.name, result.mark_presentation, result.created_at.to_formatted_s(:db)]
    end

    out
  end

  def get_fio
    fio = ''
    fio += self.last_name if self.last_name
    fio += ' '+self.first_name[0] if self.first_name
    fio += '. '+self.father_name[0]+'.' if self.father_name
    fio
  end

end

