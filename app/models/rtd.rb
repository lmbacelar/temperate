class Rtd < ActiveRecord::Base
  attr_accessible  :name, :r0, :a, :b, :c
  
  validates_uniqueness_of   :name
  validates_presence_of     :name, :r0, :a, :b, :c
  validates_numericality_of :r0, :a, :b, :c

end
