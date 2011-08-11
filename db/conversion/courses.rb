cnn = Course.column_names
copy = "COPY courses (id, group_id, name, address, phone, created_at, updated_at, link) FROM stdin;"
cno = copy.slice(/\([^\)]+\)/)[1..-2].split(", ")

inFile	= Rails.root.join("db/conversion","courses.txt")
Course.delete_all
IO.foreach(inFile) {|line| 
	field = line.split("\t")
	col = {}
	
	col['id'] = field[0] == '\N' ? nil : field[0]
	col['group_id'] = field[1] == '\N' ? nil : field[1]
	col['name'] = field[2] == '\N' ? nil : field[2]
	col['address'] = field[3] == '\N' ? nil : field[3]
	col['phone'] = field[4] == '\N' ? nil : field[4]
	col['link'] = field[7] == '\N' ? nil : field[7]
	col['created_at'] = field[5] == '\N' ? nil : field[5]
	col['updated_at'] = field[6] == '\N' ? nil : field[6]
 
	rec = Course.new
	col.each {|k,v| 
		rec[k] = v
	}
  puts rec.inspect
	rec.save
	

}
