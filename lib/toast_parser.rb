class ToastParser
  def self.parse(toast_params)
    incoming_file = toast_params[:parser_file]
    toast = Toast.create(toast_params)

    parse_path = Rails.root.join('public', 'parser', 'questions.pf')
    FileUtils.mv(incoming_file.tempfile, parse_path)

    file, text, current = File.open(parse_path, 'r'), nil, nil
    if file.gets.chop != 'LOCKED'
      FileUtils.rm(parse_path)
      return
    end

    while line = file.gets
      if line.first == '-'
        unless current
          current = Question.create(toast: toast, text: text, question_type: 2)
          text = nil
        end
        is_right = line.chop.last == '+'
        Plural.create(text: is_right ? line[1..-3] : line[1..-1], is_right: is_right, question: current)
      elsif text
        text += line.chop
      else
        text, current = line.chop, nil
      end
    end

    FileUtils.rm(parse_path)
    toast
  end
end
