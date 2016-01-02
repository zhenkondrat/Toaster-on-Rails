module Roles
  ROLE_ADMIN = 'admin'
  ROLE_TEACHER = 'teacher'
  ROLE_STUDENT = 'student'

  def role_name(role)
    case role
    when :admin then ROLE_ADMIN
    when :teacher then ROLE_TEACHER
    when :student then ROLE_STUDENT
    else fail "wrong role '#{role}' can be(:admin, :teacher, :student)"
    end
  end
end
