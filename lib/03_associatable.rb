require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  attr_reader :name, :options

  def initialize(name, options = {})
    @name = name
    @options = options
  end

  def class_name
    return options[:class_name] if options.has_key?(:class_name)
    name.to_s.capitalize.singularize
  end

  def foreign_key
    return options[:foreign_key] if options.has_key?(:foreign_key)
    "#{name}_id".to_sym
  end

  def primary_key
    return options[:primary_key] if options.has_key?(:primary_key)
    :id
  end
end

class HasManyOptions < AssocOptions
  attr_reader :self_class_name, :name, :options

  def initialize(name, self_class_name, options = {})
    @name = name
    @options = options
    @self_class_name = self_class_name
  end

  def class_name
    return options[:class_name] if options.has_key?(:class_name)
    name.to_s.capitalize.singularize
  end

  def foreign_key
    return options[:foreign_key] if options.has_key?(:foreign_key)
    "#{self_class_name.downcase}_id".to_sym
  end

  def primary_key
    return options[:primary_key] if options.has_key?(:primary_key)
    :id
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})

    options = BelongsToOptions.new(name, options)

    target_model = name.to_s.capitalize.constantize

    foreign_key_column = options.options[:foreign_key]

    define_method(name) do
      foreign_key = self.send(foreign_key_column)

      target_model.where(primary_key: foreign_key)
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, options)

    target_model = name.to_s.capitalize.constantize

    foreign_key_column = options.options[:foreign_key]

    define_method(name) do
      foreign_key = self.send(foreign_key_column)

      target_model.where(primary_key: foreign_key)
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  extend Associatable
end
