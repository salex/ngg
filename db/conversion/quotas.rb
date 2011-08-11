cnn = Quota.column_names
copy = "COPY quotas (id, member_id, tee_id, quota, lastplayed, stared, created_at, updated_at, history) FROM stdin;"
cno = copy.slice(/\([^\)]+\)/)[1..-2].split(", ")

inFile	= Rails.root.join("db/conversion","quotas.txt")
Quota.delete_all
IO.foreach(inFile) {|line| 
	field = line.split("\t")
	col = {}
	
	col['id'] = field[0] == '\N' ? nil : field[0]
	col['member_id'] = field[1] == '\N' ? nil : field[1]
	col['tee_id'] = field[2] == '\N' ? nil : field[2]
	col['quota'] = field[3] == '\N' ? nil : field[3]
	col['last_played'] = field[cno.index('lastplayed')] == '\N' ? nil : field[cno.index('lastplayed')]
	col['history'] = field[8] == '\N' ? nil : field[8]
	col['limited'] = field[cno.index('stared')] == '\N' ? nil : field[cno.index('stared')]
	col['created_at'] = field[6] == '\N' ? nil : field[6]
	col['updated_at'] = field[7] == '\N' ? nil : field[7]
   
	rec = Quota.new
	col.each {|k,v| 
		rec[k] = v
	}
	rec.save
	

}


