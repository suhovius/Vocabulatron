class Word
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :original, type: String
  
  key :original
  
  validates_uniqueness_of :original
  
  index :original, unique: true
  
end
