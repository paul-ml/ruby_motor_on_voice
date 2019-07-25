require 'bundler'

Bundler.require
post '/' do
  Ralyxa::Skill.handle(request)
end
