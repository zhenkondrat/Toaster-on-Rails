module QuestionTypes
  TYPE_LOGICAL = 'logical'
  TYPE_PLURAL = 'plural'
  TYPE_ASSOCIATIVE = 'associative'
  TYPE_LIST = [TYPE_PLURAL, TYPE_LOGICAL, TYPE_ASSOCIATIVE]

  def type_name(type)
    case type
    when :logical then TYPE_LOGICAL
    when :plural then TYPE_PLURAL
    when :associative then TYPE_ASSOCIATIVE
    else fail "wrong type '#{type}' can be(:logical, :plural, :associative)"
    end
  end
end
