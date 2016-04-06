class InsertHelper
  attr_accessor :table_name, :klass

  def initialize(klass: nil, table_name: nil)
    fail 'no class or table_name set' if klass.nil? && table_name.nil?
    @klass = klass
    @table_name = table_name || klass.table_name
  end

  def insert!(cols: [], rows: [], set_timestamps: false)
    return if rows.empty?
    validate_cols(cols)
    cols = set_cols if cols.empty?
    cols, rows = set_timestamps(cols, rows) if set_timestamps

    rows =
      rows.map do |row|
        row.map{ |value| format_value(value) }.join(', ')
      end
    rows = rows.join('), (')

    ActiveRecord::Base.connection.execute <<-SQL
      INSERT INTO #{table_name} (#{cols.join(', ')}) VALUES (#{rows})
    SQL
  end

  private

  def validate_cols(cols)
    fail 'Wrong cols type' unless cols.kind_of?(Array)
    fail %q|Columns can't be empty without class given| if klass.nil? && cols.empty?
  end

  def set_cols
    cols = klass.attribute_names
    cols - %w(id created_at updated_at)
  end

  def format_value(value)
    case
    when %w(Fixnum Float).include?(value.class.name) then value
    when value.kind_of?(Time) then "'#{value.to_s(:db)}'"
    else "'#{value}'"
    end
  end

  def set_timestamps(cols, rows)
    cols += [:created_at, :updated_at]
    time = Time.zone.now
    rows = rows.map{ |row| [*row, time, time] }
    [cols, rows]
  end
end
