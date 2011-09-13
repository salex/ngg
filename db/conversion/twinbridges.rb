#!/usr/bin/env /Users/salex/work/ngg/script/rails runner

def create_member(line)
  c = line.rstrip.split("\t")
  m = Member.new
  m.last_name = c[0]
  m.first_name = c[1]
  m.quota = c[2].to_i
	g = 6
  tee = c[4]
  if tee.blank?
    if m.quota > 32
      tee = "B"
    else
      tee = "C"
    end
  end
  m.tee = tee
	m.group_id = g
	m.status = "Active"
  r = []
  16.downto(7) { |i|
    if !c[i].blank?
      r << c[i].to_i
    end
  }
	m.save
  create_rounds(m,r)
end

def create_rounds(member,rounds)
	cd = Date.today
	thash = {"P" => 10, "B" => 12, "M" => 14, "F" => 15, "C" => 16}

  rounds.each do |points|
	  cd -= 1
		r = Round.new
		r.date = cd
		r.member_id = member.id
		r.tee_id = thash[member.tee]
		r.quota = member.quota
		r.points_pulled = points
		r.plus_minus = r.points_pulled - r.quota
		r.save
    #puts "#{round} #{member.first_name} #{member.last_name}  #{member.tee} #{rounds.inspect}"
  end
end



text = <<-END_OF_STRING
ALEX	STEVE	18	17.60	M			18	13	19	17	21					
JORDAN	CRAIG	31	30.57	C			30	27	27	28	33	36	33	30	35	37
ALLEN	PAUL	25	25.00				25	25								
ARMSTRONG	LUKE	32	31.75				30	34	34	29						
BEARDEN	DAVID	28	27.88				27	30	27	23	31	25	30	30	27	28
BLACK 	JERRY	18	18.00				18	18								
BLACKWELL	DOUG	33	33.20	B			28	30	42	28	30	27	36	37	36	38
BONE	DANI	18	18.00				18	18								
BONE	SAM	33	32.50				30	35								
BRACKETT	SCOTT	16	16.00				16	14	15	16	15	20	20	12		
BROWN	WAYNE	24	24.22	M			20	25	24	27	25	25	24	22	26	20
CHAVERS	KING	28	28.44				29	28	31	24	26	28	28	33	29	25
COLE	TY	40	39.67				38	40	37	35	43	43	42	41	38	
COLLINS	JASON	29	29.00				27	31								
DAVIDSON	HAL	26	25.57				26	27	30	16	24	29	27			
EILAND	RON	31	30.50				30	31								
FERGUSON	CHAD	35	35.00				27	43								
GRAY	ANDRE	28	27.60				26	24	27	27	34					
HAMPTON	RICKY	27	26.50				26	27								
HARPER	MARK	27	26.50				26	23	29	28						
HESTER	JOEY	25	24.50				24	27	16	30	19	27	23	28	23	28
HOLLAND	CORBAN	38	37.89				35	40	38	41	31	40	36	42	38	
HOLLAND	GREG	17	16.50				15	18								
KEEL	BUD	32	32.25	M			24	45	30	37	29	32	28	33	34	28
KEENER	NEAL	34	34.00	 	 	  	32	24	44	36						
LASSETER	JEFF	24	24.00				26	24	22	24						
LEE	JOHN	21	20.50				18	17	14	26	24	24				
LOGAN	GREG	34	34.25	B			39	31	30	39	32	36	30	37	34	33
MAYES	CAREY	27	26.50				26	27								
MEDDERS	CHUCK	29	28.50				26	30	32	26						
MORGAN	KEITH	28	28.29				22	28	31	30	27	30	30	35	31	22
MORGAN	T C	23	23.00				20	23	22	25	24	27	23	23	23	20
MUSKETT	KEVIN	33	33.29				30	32	35	38	37	32	29			
PRUITT	AVERY	30	30.00				27	27	36							
ROGERS	JERALD	30	29.80				28	34	27	22	38					
SALVADOR	STEVE	30	29.60				28	39	26	29	26					
SHEW	LENDON	19	18.50				21	16								
SHIELDS	JASON	27	26.50				25	28								
SMITH	JOHNNY	22	21.71				24	23	17	23	23	18	24			
SPURLIN	RANDY	36	35.50				32	39								
SPURLOCK	MARK	31	30.50				32	29								
TANNER	BUTCH	28	28.44				32	24	25	31	29	28	30	24	33	26
WILDER	BOB	27	27.00				27	27								
WILLIAMON	JOHNNY	25	25.00	 			25	25								
WOODALL	BOB	24	24.17				20	27	28	29	21	20						
END_OF_STRING

lines = text.split("\n")

lines.each do |line|
  create_member(line)
end

g = Group.find(6)
g.recompute_members_quotas