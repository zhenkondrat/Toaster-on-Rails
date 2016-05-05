module ApplicationHelper
  def reverse_language
    I18n.locale == :en ? :uk : :en
  end
end
