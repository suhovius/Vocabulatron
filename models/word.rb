class Word
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :original, type: String
  field :translation, type: String
  
  field :lang, type: String
  
  #key :original
  
  validates_uniqueness_of :original
  
  index :original, unique: true
  
  
  before_save :set_lang_and_translation
  
  def translate(from = self.lang, to = 'ru')
    translator = BingTranslator.new("#{Settings.bing_translator_api_key}")
    translator.translate self.original, :from => from, :to => to
  end
  
  protected
    def set_lang_and_translation
      translator = BingTranslator.new("#{Settings.bing_translator_api_key}")
      self.lang = translator.detect self.original
      self.translation = self.translate
    end
  
end
