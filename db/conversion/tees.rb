cnn = Tee.column_names
copy = "COPY tees (id, course_id, tee, color, slope, rating, par_in, par_out, created_at, updated_at) FROM stdin;"
cno = copy.slice(/\([^\)]+\)/)[1..-2].split(", ")

inFile	= Rails.root.join("db/conversion","tees.txt")
Tee.delete_all
IO.foreach(inFile) {|line| 
	field = line.split("\t")
	col = {}
	
	col['id'] = field[0] == '\N' ? nil : field[0]
	col['course_id'] = field[1] == '\N' ? nil : field[1]
	col['tee'] = field[2] == '\N' ? nil : field[2]
	col['color'] = field[3] == '\N' ? nil : field[3]
	col['slope'] = field[4] == '\N' ? nil : field[4]
	col['rating'] = field[5] == '\N' ? nil : field[5]
	col['par_in'] = field[6] == '\N' ? nil : field[6]
	col['par_out'] = field[7] == '\N' ? nil : field[7]
	col['created_at'] = field[8] == '\N' ? nil : field[8]
	col['updated_at'] = field[9] == '\N' ? nil : field[9]
  
	rec = Tee.new
	col.each {|k,v| 
		rec[k] = v
	}
  puts rec.inspect
	rec.save
	

}


