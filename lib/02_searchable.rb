require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    where_line = params.map { |attr_name, value| "#{attr_name} = ?" }

    results = DBConnection.execute(<<-SQL, *params.values)
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      #{where_line.join("AND ")}
    SQL

    self.parse_all(results)
  end
end

class SQLObject
  extend Searchable
end
