module ResultsHelper
  def set_header(p_type, filename)
    case p_type
      when 'xls'
        headers['Content-Type'] = "application/vnd.ms-excel; charset=UTF-8'"

      when 'doc'
        headers['Content-Type'] = "application/vnd.ms-word; charset=UTF-8"
    end
    headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
    headers['Cache-Control'] = ''
  end
end
