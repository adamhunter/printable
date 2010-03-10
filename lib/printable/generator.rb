require 'rubygems'
require 'sinatra/base'
require 'erb'

module Printable
  class Generator < Sinatra::Base
    
    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/generator/views"
    set :public, "#{dir}/generator/public"
    set :static, true
    
    get '/' do
      erb :index
    end
    
  end
end

