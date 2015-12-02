class InsertHelper
  attr_accessor :table_name

  def initialize(klass: nil, table_name: nil)
    return fail 'no class or table_name set' unless klass || table_name
    @table_name = table_name || klass.table_name
  end

  def insert!(cols: [], rows: [])
    return if cols.kind_of?(Array) && cols.empty?
    values = rows.map{ |row| row.map{|v| %w(Fixnum Float).include?(v.class.name) ? v : "'#{v}'"}.join(', ') }.join('), (')

    ActiveRecord::Base.connection.execute <<-SQL
      INSERT INTO #{table_name} (#{[*cols].join(', ')}) VALUES (#{values})
    SQL
  end
end
