require 'bundler'
require './lib/motor'
require './lib/mqtt_client'

MqttClient._load
Bundler.require
post '/' do
  Ralyxa::Skill.handle(request)
end

get '/motor/status' do
  status = Motor.running? ? "Running" : "Stopped"
  status
end
