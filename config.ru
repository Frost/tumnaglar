require 'dragonfly'
require 'unicorn'
require 'sinatra'
require 'rack/cache'
require 'yaml'
require 'ostruct'
require_relative 'tumnaglar'

config_yaml = YAML.load(File.read(File.join(__dir__, "config.yml")))
config = OpenStruct.new(config_yaml[ENV["RACK_ENV"]])

Dragonfly.app.configure do
  plugin :imagemagick
  response_header "Cache-Control", config.dragonfly["cache_response_header"]
  datastore :file, root_path: config.dragonfly["datastore_path"]
end

use Rack::Cache, config.cache

tumnaglar = Tumnaglar.new(config)

before do
  response.headers['Cache-Control'] = config.dragonfly["cache_response_header"]
end

get "/:username" do |username|
  halt tumnaglar.get_image(username).to_response(env)
end

get "/:username/:size" do |username, size|
  begin
    halt tumnaglar.get_image(username).thumb(size).to_response(env)
  rescue ArgumentError => e
    puts e.message
    puts e.backtrace
    status 400
    halt
  end
end

run Sinatra::Application

