cnn = Member.column_names
copy = "COPY members (id, group_id, name, nickname, phone_home, phone_cell, address, status, list_contact, picture_url, tee, lastplayed, quota, roles, created_at, updated_at, stared, initial_quota) FROM stdin;"
cno = copy.slice(/\([^\)]+\)/)[1..-2].split(", ")

inFile	= Rails.root.join("db/conversion","members.txt")
#Member.delete_all
IO.foreach(inFile) {|line| 
	field = line.split("\t")
	col = {}
	col['id'] = field[0] == '\N' ? nil : field[0]
	col['group_id'] = field[1] == '\N' ? nil : field[1]
	#col['email'] = field[cno.index('xxx')] == '\N' ? nil : field[cno.index('xxx')]
	name = field[2].split(" ")
	col['last_name'] = name[1]
	col['first_name'] = name[0]
	col['phone'] = field[cno.index('phone_home')] == '\N' ? nil : field[cno.index('phone_home')]
	col['cell'] = field[cno.index('phone_cell')] == '\N' ? nil : field[cno.index('phone_cell')]
	col['address'] = field[6] == '\N' ? nil : field[6]
	col['list_contact'] = field[8] == '\N' ? nil : field[8] == 't'
	col['status'] = field[7] == '\N' ? nil : field[7]
	col['created_at'] = field[14] == '\N' ? nil : field[14]
	col['updated_at'] = field[15] == '\N' ? nil : field[15]
	col['last_played'] = field[cno.index('lastplayed')] == '\N' ? nil : field[cno.index('lastplayed')]
	col['quota'] = field[12] == '\N' ? nil : field[12].to_i
	col['limited'] = field[cno.index('stared')] == '\N' ? nil : field[cno.index('stared')] == 't'
	col['initial_quota'] = field[17] == '\N' ? nil : field[17].to_i
	col['tee'] = field[10] == '\N' ? nil : field[10]
	
	m = Member.new
	col.each {|k,v| 
		m[k] = v
	}
  puts m.inspect
	m.save
	
}