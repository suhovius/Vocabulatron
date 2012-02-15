class Word
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :original, type: String
end
