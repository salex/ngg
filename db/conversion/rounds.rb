cnn = Round.column_names
copy = "COPY rounds (id, member_id, event_id, tee_id, date, quota, points_pulled, plus_minus, par_in, par_out, score, round_quality, skin_quality, place, created_at, updated_at, team, gross_pulled, net_pulled) FROM stdin;"
cno = copy.slice(/\([^\)]+\)/)[1..-2].split(", ")

inFile	= Rails.root.join("db/conversion","rounds.txt")
Round.delete_all
IO.foreach(inFile) {|line| 
  field = line.split("\t")
  col = {}

  col['id'] = field[0] == '\N' ? nil : field[0]
  col['member_id'] = field[1] == '\N' ? nil : field[1]
  col['event_id'] = field[2] == '\N' ? nil : field[2]
  col['tee_id'] = field[3] == '\N' ? nil : field[3]
  col['date'] = field[4] == '\N' ? nil : field[4]
  col['quota'] = field[5] == '\N' ? nil : field[5]
  col['points_pulled'] = field[6] == '\N' ? nil : field[6]
  col['plus_minus'] = field[7] == '\N' ? nil : field[7]
  col['par_in'] = field[8] == '\N' ? nil : field[8]
  col['par_out'] = field[9] == '\N' ? nil : field[9]
  col['score'] = field[10] == '\N' ? nil : field[10]
  col['round_quality'] = field[11] == '\N' ? nil : field[11]
  col['skin_quality'] = field[12] == '\N' ? nil : field[12]
  col['other_quality'] = nil #field[cno.index('xxx')] == '\N' ? nil : field[cno.index('xxx')]
  col['place'] = field[13] == '\N' ? nil : field[13]
  col['team'] = field[16] == '\N' ? nil : field[16]
  col['gross_pulled'] = field[17] == '\N' ? col['points_pulled'] : field[17]
  col['net_pulled'] = field[18].strip  == '\N'  ? col['points_pulled'] : field[18].strip 
  col['created_at'] = field[14] == '\N' ? nil : field[14]
  col['updated_at'] = field[15] == '\N' ? nil : field[15]

  
  rec = Round.new
  col.each {|k,v| 
  	rec[k] = v
  }
  #puts rec.inspect
  rec.save

}
