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

  def toasts
    Toast.joins('INNER JOIN toast_groups ON toast_groups.toast_id = toasts.id
                INNER JOIN user_groups ON toast_groups.group_id = user_groups.group_id
                INNER JOIN users ON users.id = '+self.id.to_s)
              .select('toast.id, toast.name')
  end

  def results count = nil
    results = if count
                Result.where(user_id: self.id).order(created_at: :desc).limit(count)
              else
                Result.where(user_id: self.id).order(created_at: :desc)
              end
    out = []

    results.each do |result|
      toast = Toast.find(result.toast_id)
      out.push [toast.get_subject_name, toast.name, result.mark_presentation, result.created_at.to_formatted_s(:db)]
    end

    out
  end

  def result toast_id
    results = Result.where(user_id: self.id, toast_id: toast_id).order(created_at: :desc)
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
      toast = Toast.find(result.toast_id)
      out.push [toast.get_subject_name, toast.name, result.mark_presentation, result.created_at.to_formatted_s(:db)]
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

