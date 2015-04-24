module ResultsHelper
  def set_header(p_type, filename)
    case p_type
      when 'xls'
        headers['Content-Type'] = "application/vnd.ms-excel; charset=UTF-8'"
        headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
        headers['Cache-Control'] = ''

      when 'dox'
        headers['Content-Type'] = "application/vnd.ms-word; charset=UTF-8"
        headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
        headers['Cache-Control'] = ''
    end
  end
end