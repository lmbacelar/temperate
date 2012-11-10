class Sprt < ActiveRecord::Base
  attr_accessible :name, :range, :rtpw, :a, :b, :c, :d, :w660, :c1, :c2, :c3, :c4, :c5

  validates_uniqueness_of   :name
  validates_presence_of     :name, :range, :rtpw, :a, :b, :c, :d, :w660, :c1, :c2, :c3, :c4, :c5
  validates_numericality_of :range, :rtpw, :a, :b, :c, :d, :w660, :c1, :c2, :c3, :c4, :c5
end
