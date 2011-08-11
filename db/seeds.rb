# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#require File.expand_path('../conversion/members', __FILE__)
require File.expand_path('../conversion/groups', __FILE__)
require File.expand_path('../conversion/courses', __FILE__)
require File.expand_path('../conversion/tees', __FILE__)
require File.expand_path('../conversion/quotas', __FILE__)
require File.expand_path('../conversion/images', __FILE__)
require File.expand_path('../conversion/events', __FILE__)
require File.expand_path('../conversion/rounds', __FILE__)
