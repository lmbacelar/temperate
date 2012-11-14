class Thermocouple < ActiveRecord::Base
  VALID_KINDS = [:b, :c, :e, :j, :k, :n, :r, :s, :t]

  attr_accessible :name, :kind, :a3, :a2, :a1, :a0
  
  validates_uniqueness_of   :name
  validates_presence_of     :name, :kind, :a3, :a2, :a1, :a0
  validates_inclusion_of    :kind, in: VALID_KINDS
  validates_numericality_of :a3, :a2, :a1, :a0
end
