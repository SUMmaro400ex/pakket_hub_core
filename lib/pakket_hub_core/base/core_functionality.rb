module PakketHub::CoreFunctionality
  def self.included(base)
    base.send(:attr_accessor, :developer_driven, :system_driven)
    #base.send(:extend, ClassMethods)
  end

  module ClassMethods
  end

  def load_through(list, assoc)
    list = [list].flatten
    if list.empty?
      []
    else
      grouped = list.group_by(&:class)
      sym_assoc = assoc.to_sym
      grouped.each_pair do |klass, objects|
        foreign_key = if klass.reflect_on_association(sym_assoc).try(:macro) == :belongs_to
          klass.reflect_on_association(sym_assoc).try(:foreign_key)
        end
        filtered = foreign_key ? objects.select(&foreign_key.to_sym) : objects
        PakketHub::EagerLoader.load(filtered, assoc) if filtered.present?
      end
      result = list.flat_map(&sym_assoc)
      result.compact!
      result.uniq!
      result
    end   
  end 

  def developer_driven?
    !!developer_driven
  end

  def system_driven?
    !!system_driven
  end
end