cnn = Event.column_names
copy = "COPY events (id, group_id, course_id, date, teetime, remarks, teams, places, place_percent, created_at, updated_at) FROM stdin;"
cno = copy.slice(/\([^\)]+\)/)[1..-2].split(", ")

inFile	= Rails.root.join("db/conversion","events.txt")
Event.delete_all
IO.foreach(inFile) {|line| 
	field = line.split("\t")
	col = {}
	

	col['id'] = field[0] == '\N' ? nil : field[0]
	col['group_id'] = field[1] == '\N' ? nil : field[1]
	col['course_id'] = field[2] == '\N' ? nil : field[2]
	col['date'] = field[3] == '\N' ? nil : field[3]
	col['teetime'] = field[4] == '\N' ? nil : field[4]
	col['remarks'] = field[5] == '\N' ? nil : field[5]
	col['teams'] = field[6] == '\N' ? nil : field[6]
	col['places'] = field[7] == '\N' ? nil : field[7]
	col['place_percent'] = field[8] == '\N' ? nil : field[8]
	col['created_at'] = field[9] == '\N' ? nil : field[9]
	col['updated_at'] = field[10].strip  == '\N' ? nil : field[10].strip 
 
	rec = Event.new
	col.each {|k,v| 
		rec[k] = v
	}
	rec.save
	

}
