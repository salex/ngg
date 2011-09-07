# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Member.delete_all
#Group.delete_all
#Course.delete_all
#Tee.delete_all
Quota.delete_all
Image.delete_all
Round.delete_all
Article.delete_all
Comment.delete_all
Event.delete_all

require File.expand_path('../conversion/members', __FILE__)
#require File.expand_path('../conversion/groups', __FILE__)
#require File.expand_path('../conversion/courses', __FILE__)
#require File.expand_path('../conversion/tees', __FILE__)
require File.expand_path('../conversion/quotas', __FILE__)
#require File.expand_path('../conversion/images', __FILE__)
require File.expand_path('../conversion/events', __FILE__)
require File.expand_path('../conversion/rounds', __FILE__)

ActiveRecord::Base.connection.reset_pk_sequence!('members')
ActiveRecord::Base.connection.reset_pk_sequence!('groups')
ActiveRecord::Base.connection.reset_pk_sequence!('courses')
ActiveRecord::Base.connection.reset_pk_sequence!('tees')
ActiveRecord::Base.connection.reset_pk_sequence!('quotas')
ActiveRecord::Base.connection.reset_pk_sequence!('images')
ActiveRecord::Base.connection.reset_pk_sequence!('rounds')
ActiveRecord::Base.connection.reset_pk_sequence!('articles')
ActiveRecord::Base.connection.reset_pk_sequence!('comments')
ActiveRecord::Base.connection.reset_pk_sequence!('events')
ActiveRecord::Base.connection.reset_pk_sequence!('users')

