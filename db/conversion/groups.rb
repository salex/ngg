cnn = Group.column_names
copy = "COPY groups (id, name, subdomain, notices, use_course_quota, use_hilo, use_star, use_course_star, hilo_limit, star_limit, quota_limit, created_at, updated_at, round_dues, skin_dues, star_max_points, use_best_rounds, round_limit, use_plus_minus_limit, plus_minus_limit) FROM stdin;"
cno = copy.slice(/\([^\)]+\)/)[1..-2].split(", ")

inFile	= Rails.root.join("db/conversion","groups.txt")
Group.delete_all
IO.foreach(inFile) {|line| 
	field = line.split("\t")
	puts " Start fields #{field.length()} lins #{line}"
	col = {}
	
	col['id'] = field[0] == '\N' ? nil : field[0].to_i
	col['name'] = field[1] == '\N' ? nil : field[1]
	col['subdomain'] = field[2] == '\N' ? nil : field[2]
	col['created_at'] = field[11] == '\N' ? nil : field[11]
	col['updated_at'] = field[12] == '\N' ? nil : field[12]
	col['uses_multiple_courses'] = true
	col['uses_course_quota'] = true
	col['uses_best_rounds'] = false
	col['best_rounds_minimum'] = nil
	col['best_rounds_maximum'] = nil
	col['rounds_used'] = field[cno.index('quota_limit')] == '\N' ? nil : field[cno.index('quota_limit')].to_i
	col['uses_new_member_limit'] = field[cno.index('use_star')] == '\N' ? nil : field[cno.index('use_star')] == "t"
	col['new_member_limit'] = field[cno.index('star_max_points')] == '\N' ? nil : field[cno.index('star_max_points')].to_i
	col['new_member_rounds_used'] = field[cno.index('star_limit')] == '\N' ? nil : field[cno.index('star_limit')].to_i
	col['uses_round_limit'] = field[cno.index('use_plus_minus_limit')] == '\N' ? nil : field[cno.index('use_plus_minus_limit')]
	col['round_limit'] = field[19] == '\N' ? nil : field[19]
	col['uses_new_course_limit'] = true
	col['uses_high_low_rounds_rule'] = field[cno.index('use_hilo')] == '\N' ? nil : field[cno.index('use_hilo')] == "t"
	col['high_low_rounds_effective'] = field[cno.index('hilo_limit')] == '\N' ? nil : field[cno.index('hilo_limit')].to_i
	col['round_dues'] = field[13] == '\N' ? nil : field[13]
	col['skins_dues'] = field[cno.index('skin_dues')] == '\N' ? nil : field[cno.index('skin_dues')]
	col['other_game'] = nil
	col['other_dues'] = nil
	col['points_double_eagle'] = 5
	col['points_eagle'] = 4
	col['points_birdie'] = 3
	col['points_par'] = 2
	col['points_bogey'] = 1
	col['points_double_bogey'] = 0
	col['trim_round_days'] = 360
	
	col['pot_splits'] = "[100],[60,40],[50,30,20],[40,30,20,10],[30,25,20,15,10]"
	puts "GROUP #{col["id"]} fields #{field.length()}"
  
	rec = Group.new
	col.each {|k,v| 
		rec[k] = v
	}
  
	puts "ID   #{rec.id}"
	puts rec.inspect
	puts "nil #{rec.id.nil?}"
	rec.save
	a = Article.new
  a.group_id = rec.id
  a.user_id = 1
  a.body = "**Who**\r\n\r\n**What**\r\n\r\n**Where**\r\n\r\n**When**\r\n\r\n**Why**\r\n"
  a.title = "About " + rec.name
  a.type_article = "Welcome"
  a.save
	
	puts "END"
	
 
}
