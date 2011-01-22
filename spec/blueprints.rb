require 'machinist/mongoid'
require 'sham'
require 'faker'

Sham.codename { |n| "codename_#{n}" }

Project.blueprint do
  client_name { Faker::Name.name }
  email { Faker::Internet.email }
  codename { Sham.codename }
  phone '0204284106'
  remarks 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
end
