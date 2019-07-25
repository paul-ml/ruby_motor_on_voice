require 'bundler'
require './lib/motor'

Bundler.require
post '/' do
  Ralyxa::Skill.handle(request)
end

get '/motor/status' do
  status = Motor.running? ? "Running" : "Stopped"
  status
end
