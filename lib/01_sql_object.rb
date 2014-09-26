require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    columns = DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    SQL

    columns[0].map(&:to_sym)
  end

  def self.finalize!
    columns.each do |column|
      define_method(column) { attributes[column] }

      define_method("#{column}=") do |value|
        attributes[column] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    all_rows = DBConnection.execute(<<-SQL)
    SELECT
      #{self.table_name}.*
    FROM
      #{self.table_name}
    SQL

    self.parse_all(all_rows)
  end

  def self.parse_all(results)
    results.map do |result_hash|
      self.new(result_hash)
    end
  end

  def self.find(id)
    record = DBConnection.execute(<<-SQL, id)
    SELECT
      #{self.table_name}.*
    FROM
      #{self.table_name}
    WHERE
      #{self.table_name}.id = ?
    SQL

    self.new(record[0])
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym

    unless self.class.columns.include?(attr_name)
      raise "unknown attribute '#{attr_name}'"
    end

    self.send("#{attr_name}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
