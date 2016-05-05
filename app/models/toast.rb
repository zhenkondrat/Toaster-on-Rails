class Toast < ActiveRecord::Base
  paginates_per 10

  belongs_to :owner, class_name: 'User'
  belongs_to :subject
  belongs_to :mark_system
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :questions
  has_many :results, dependent: :delete_all

  store_accessor :options, :questions_count, :answer_time_limit,
                 :weights, :learning_flag

  validates :subject, :name, :mark_system, presence: true
  validate  :answer_time_limits
  validate  :questions_count_limits
  before_validation :set_default_weights

  attr_accessor :parser_file

  def self.search(user, subject_id: nil, name: nil, group_id: nil)
    toasts = user.admin? ? Toast.all : Toast.where(subject_id: user.subjects.ids)
    toasts = toasts.where(subject_id: subject_id) unless subject_id.nil?
    unless name.nil?
      name = Toast.sanitize(name)
      toasts = toasts.where("toasts.name LIKE '%#{name[1..-2]}%'")
    end
    toasts = toasts.joins(:groups).where(groups: {id: group_id}) unless group_id.nil?
    toasts
  end

  def get_questions_list
    shuffeled = questions.shuffle
    questions_count.nil? ? shuffeled : shuffeled[0..questions_count-1]
  end

  def foreign_groups
    Group.where.not(id: groups)
  end

  private

  def set_default_weights
    %w(logical plural associative).each do |name|
      self.weights[name] = 1 if weights[name].blank?
    end
  end

  def answer_time_limits
    return if answer_time_limit.nil?
    unless answer_time_limit.kind_of? Integer
      errors.add(:answer_time_limit, 'wrong attribute type')
      return
    end

    errors.add(:answer_time_limit, 'must be greater then 10') if answer_time_limit < 10
  end

  def questions_count_limits
    return if questions_count.nil?
    unless questions_count.kind_of? Integer
      errors.add(:questions_count, 'wrong attribute type')
      return
    end

    errors.add(:questions_count, 'must be greater then 0') if questions_count < 1
    if questions_count > questions.count
      error_message = %q|Count to answer can't be higher then actual questions count|
      errors.add(:questions_count, error_message)
    end
  end
end
