# Required gems
require 'rubygems'
require 'sinatra/base'
require 'mongoid'
require 'haml'
require 'settingslogic'
require 'bing_translator'

# Required files
require './models/settings'
require './models/word'

class Vocabulatron < Sinatra::Base
  # directory path settings relative to app file
  set :root, Vocabulatron.root
  set :public_folder, Proc.new { File.join(root, 'public') }
  set :method_override, true
  
#  configure do
#     Mongoid.configure do |config|
#      name = "mongoid_dev"
#      host = "localhost"
#      config.master = Mongo::Connection.new.db(name)
#    end
#  end

  APP_NAME = "Vocabulatron"

  # MongoDB configuration
  Mongoid.configure do |config|
    if ENV['MONGOHQ_URL']
      conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
      uri = URI.parse(ENV['MONGOHQ_URL'])
      config.master = conn.db(uri.path.gsub(/^\//, ''))
    else
      config.master = Mongo::Connection.from_uri("mongodb://localhost:27017").db('vocabulatron_development')
    end
  end
     
  def initialize
    super
  end

  def get_all_words(layout = true)
    @words = Word.all
    haml :'words/index', :locals => { :title => "Vocabulary", :words => @words }, :layout => layout
  end
  
  get '/' do
    redirect '/words'
  end
  
  # list all words
  get '/words' do
    get_all_words
  end
  
  # new word
  get '/words/add_new' do
    haml :'words/new', :locals => { :title => "New Word"}
  end  
  
  post '/words' do
    @word = params[:word]
    @word = Word.new(params[:word])
    if @word.save
      puts 'Correct Word'
      redirect '/words'
    else
      puts "Error(s): ", @word.errors.map {|k,v| "#{k}: #{v}"}
      haml :'words/error', :locals => { :errors => @word.errors } 
    end
  end
  
  # view a word
  get '/words/:id' do
    @word = Word.find(params[:id])
    
    @english = @word.translation
    
    haml :'words/show', :locals => { :title => "Word", :word => @word, :translation => @english }
  end  
  
  # edit word
  get '/words/:id/edit' do
    @word = Word.find(params[:id]) 
    haml :'words/edit', :locals => { :title => "Edit Word", :word => @word}
  end
  
  put '/words/:id' do    
    @word = Word.find(params[:id])
    @word.update_attributes(params[:word])
    redirect '/words/'+params[:id]
  end
  
  #delete blog
  delete '/words/:id' do
    @word = Word.find(params[:id])
    @word.delete
    get_all_words(false)
  end
  
  # start the server if ruby file executed directly
  run! if app_file == $0
  
end


