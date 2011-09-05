cnn = Image.column_names
copy = "COPY images (id, name, imageable_type, created_at, updated_at, photo_file_name, photo_content_type, photo_file_size, photo_updated_at, imageable_id) FROM stdin;"
cno = copy.slice(/\([^\)]+\)/)[1..-2].split(", ")

inFile	= Rails.root.join("db/conversion","images.txt")
Image.delete_all
IO.foreach(inFile) {|line| 
	field = line.split("\t")
	col = {}
	

	col['id'] = field[0] == '\N' ? nil : field[0]
	col['imageable_type'] = field[2] == '\N' ? nil : field[2]
	col['imageable_id'] = field[9].strip  == '\N' ? nil : field[9].strip 
	col['name'] = field[1] == '\N' ? nil : field[1]
	col['photo_file_name'] = field[5] == '\N' ? nil : field[5]
	col['photo_content_type'] = field[6] == '\N' ? nil : field[6]
	col['photo_file_size'] = field[7] == '\N' ? nil : field[7]
	col['photo_updated_at'] = field[8] == '\N' ? nil : field[8]
	col['created_at'] = field[3] == '\N' ? nil : field[3]
	col['updated_at'] = field[4] == '\N' ? nil : field[4]
 
	rec = Image.new
	col.each {|k,v| 
		rec[k] = v
	}
  puts rec.inspect
	rec.save
	

}
