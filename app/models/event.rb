class Event < ActiveRecord::Base
  belongs_to :group
  belongs_to :course
  has_many :rounds, :order => 'team', :dependent => :destroy
  accepts_nested_attributes_for :rounds
  validates_presence_of :date, :places
  validates_uniqueness_of :date
  
  def valid_teams(teams)
    if teams.length > 1
      if teams.include?("Indiv")
        self.errors[:base] << "Members selected using both Team number and Individual selection - use one or the other"
        return false
      end
    end
    return true
  end
  
  def build_event(params)
    ridx = 0
    skins = get_skins(params[:add])
    each_skin = params[:team][:skins_pot].to_f / skins["good"]
    maxp = 0
    minp = 0
    tot = 0
    
    params[:add].each do |key,data|
      self.rounds[ridx][:member_id] = data[:mid]
      self.rounds[ridx][:tee_id] = data[:tee]
      self.rounds[ridx][:date] = params[:event][:date]
      self.rounds[ridx][:quota] = data[:quota]
      self.rounds[ridx][:points_pulled] = data[:gross]
      self.rounds[ridx][:plus_minus] = data[:plus_minus]
      self.rounds[ridx][:round_quality] = params[:team][:share][data[:team]].to_f / params[:team][:size][data[:team]].to_i
      self.rounds[ridx][:skin_quality] = skins[data[:mid].to_i] * each_skin if skins[data[:mid].to_i]
      self.rounds[ridx][:other_quality] = data[:other_quality]
      self.rounds[ridx][:place] = params[:team][:place][data[:team]]
      self.rounds[ridx][:team] = data[:team]
      self.rounds[ridx][:gross_pulled] = data[:gross]
      self.rounds[ridx][:net_pulled] = data[:net]
      #TODO if group["limit_gross_points"]
      data[:skin_quality] = 0
      data[:par] = ""
      data[:hole].each do |k,s|
        data[:par] += s
      end
      self.rounds[ridx][:par_in] = data[:par][0..8]
      self.rounds[ridx][:par_out] = data[:par][9..17]
      ridx += 1
      pts = data[:plus_minus].to_i
      tot += pts
      if pts > maxp
        maxp = pts
      end
      if pts < minp
        minp = pts
      end
    end
    avg = tot / ridx
    self.remarks += " {H:"+maxp.to_s+", L:"+minp.to_s+ ", A:"+avg.to_s+"}"
  end
  
  def get_skins(players)
    skins = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    skinType = ['.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.']
    skinWho = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    pts = {"A" => 5, "E" => 4, "B" => 3, "P" => 2, "O" => 1, "D" => 0, "." => nil}
    players.each do |key,player|
      holes = player["hole"].values 
      holes.each_index do |i|
        if !(/(A|E|B)/ =~ holes[i]).nil? # birdie +
          if skins[i] == 0 #set skin
            skins[i] = 1
            skinType[i] = holes[i]
            skinWho[i] = player[:mid].to_i
          elsif holes[i] == skinType[i] # skin cut
            skins[i] += 1
            skinWho[i] = 0
          elsif pts[holes[i]] > pts[skinType[i]] # took skin away with eagle or better
            skins[i] = 1
            skinType[i] = holes[i]
            skinWho[i] = player[:mid].to_i
          end
        end
      end
    end
    count = skinWho.inject(Hash.new(0)) {|who, cnt| who[cnt]+=1; who}
    count["good"] = (18 - count[0])
    #logger.info "aaaaaaaaaaa #{skins.inspect} #{skinType.inspect} #{skinWho.inspect} #{count}"
    return count
  end
  
  def self.form_event_teams(event,group,rounds)
    @skins = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    @skinType = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    @skinWho = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]


    teams = {}

    teams["course"] = event.course_id
    teams["event"] = event
    teams["team"] = []
    teams["teamtot"] = []
    teams["count"] = 0
    teams["teams"] = 0
    for round in rounds do 
      teams["count"] += 1
      membID = round.member_id
      teamID = round.team
      points = round.plus_minus
      quota = round.quota
      pulled = round.points_pulled
      round.par_in = round.par_in.nil? ? "........." : round.par_in
      round.par_out = round.par_out.nil? ? "........." : round.par_out
      par = round.par_in + round.par_out
      #bridge band-aid
      par.gsub!("B","3")
      par.gsub!("E","2")
      par.gsub!("A","1")
      tee = round.tee_id
      #starpoints =  round.gross_pulled.nil? ? pulled - quota : round.gross_pulled - quota
      net_points =  starpoints = round.net_pulled.nil? ? pulled - quota : round.net_pulled - quota
      otherquality = round.other_quality
      

      if teams["team"][teamID]
        teams["team"][teamID]["count"] += 1
        teams["team"][teamID]["total"] += starpoints
        teams["team"][teamID]["mate"].push(membID)
        teams["team"][teamID]["team"].push(teamID)
        teams["team"][teamID]["points"].push(points)
        teams["team"][teamID]["starpoints"].push(starpoints)
        teams["team"][teamID]["net_points"].push(net_points)
        teams["team"][teamID]["quota"].push(quota)
        teams["team"][teamID]["pulled"].push(pulled)
        teams["team"][teamID]["par"].push(par)
        teams["team"][teamID]["otherquality"].push(otherquality)
        teams["team"][teamID]["tee"].push(tee)
      else
        teams["team"][teamID] = {}
        teams["teams"] += 1
        teams["team"][teamID]["count"] = 1
        teams["team"][teamID]["quality"] = 0
        teams["team"][teamID]["place"] = 0
        teams["team"][teamID]["total"] = starpoints
        teams["team"][teamID]["comment"] = ""
        teams["team"][teamID]["mate"] = []
        teams["team"][teamID]["team"] = []
        teams["team"][teamID]["points"] = []
        teams["team"][teamID]["starpoints"] = []
        teams["team"][teamID]["net_points"] = []
        teams["team"][teamID]["quota"] = []
        teams["team"][teamID]["pulled"] = []
        teams["team"][teamID]["par"] = []
        teams["team"][teamID]["tee"] = []
        teams["team"][teamID]["otherquality"] = []
        teams["team"][teamID]["mate"].push(membID)
        teams["team"][teamID]["team"].push(teamID)
        teams["team"][teamID]["points"].push(points)
        teams["team"][teamID]["starpoints"].push(starpoints)
        teams["team"][teamID]["net_points"].push(net_points)
        teams["team"][teamID]["quota"].push(quota)
        teams["team"][teamID]["pulled"].push(pulled)
        teams["team"][teamID]["par"].push(par)
        teams["team"][teamID]["tee"].push(tee)
        teams["team"][teamID]["otherquality"].push(otherquality)
      end
      self.set_skins(par,membID,group.points_birdie)
    end
    teams["skins"] = @skins
    teams['skinswho'] =   @skinWho
    teams["teampot"] = teams["count"] *  group.round_dues
    teams["skinspot"] = teams["count"] * group.skins_dues ||= 0
    
    if !event.places.nil?
      places = event.places
    else
      places = ((event.teams / 2.0) + 0.5 ).to_i 
      event.places = places
    end
    teams['places'] = event.splitPot(teams["teampot"], places)  
    len = teams["team"].length
    #debugger
    j = 0
    for i in 1..len do
      if !teams["team"][i].nil?
        j += 1
        teams["teamtot"][j] = [teams["team"][i]["total"],i]
      end
    end
    
    teams["teamtot"].delete_at(0)
    # teams["team"].delete_at(0)
    if teams["count"] > 0
    
      teams = self.pay_teams(teams)
    end
    #logger.info teams.inspect
    return teams
  end
  
  
  def self.form_teams(params,group,event)
    @skins = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    @skinType = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    @skinWho = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

    teams = {}

    teams["course"] = event["course_id"]
    teams["event"] = event
    teams["team"] = []
    teams["teamtot"] = []
    teams["count"] = 0
    teams["teams"] = 0
    teams["attendees"] = {}
    
    params["memb"].each { |key,memb| 
      if memb != ""
        teams["attendees"][key] = memb
        teams["count"] += 1
        data = memb.split(":")
        #$('memb_'+ membID).value = membID +":"+ team+":"+ points+":"+ quota+":"+ pulled+":"+ par+":"+ tee
        membID = data[0].to_i
        teamID = data[1].to_i
        points = data[2].to_i
        quota = data[3]
        pulled = data[4].to_i
        par = data[5]
        tee = data[6]
        starpoints = data[7].to_i
        net_points = data[8].to_i
        otherquality = data[9].to_i

        if teams["team"][teamID]
          teams["team"][teamID]["count"] += 1
          teams["team"][teamID]["total"] += starpoints
          teams["team"][teamID]["mate"].push(membID)
          teams["team"][teamID]["team"].push(teamID)
          teams["team"][teamID]["points"].push(points)
          teams["team"][teamID]["starpoints"].push(starpoints)
          teams["team"][teamID]["net_points"].push(net_points)
          teams["team"][teamID]["quota"].push(quota)
          teams["team"][teamID]["pulled"].push(pulled)
          teams["team"][teamID]["par"].push(par)
          teams["team"][teamID]["tee"].push(tee)
          teams["team"][teamID]["otherquality"].push(otherquality)
        else
          teams["team"][teamID] = {}
          teams["teams"] += 1
          teams["team"][teamID]["count"] = 1
          teams["team"][teamID]["quality"] = 0
          teams["team"][teamID]["place"] = 0
          teams["team"][teamID]["total"] = starpoints
          teams["team"][teamID]["comment"] = ""
          teams["team"][teamID]["mate"] = []
          teams["team"][teamID]["team"] = []
          teams["team"][teamID]["points"] = []
          teams["team"][teamID]["starpoints"] = []
          teams["team"][teamID]["net_points"] = []
          teams["team"][teamID]["quota"] = []
          teams["team"][teamID]["pulled"] = []
          teams["team"][teamID]["par"] = []
          teams["team"][teamID]["tee"] = []
          teams["team"][teamID]["otherquality"] = []
          teams["team"][teamID]["mate"].push(membID)
          teams["team"][teamID]["team"].push(teamID)
          teams["team"][teamID]["points"].push(points)
          teams["team"][teamID]["starpoints"].push(starpoints)
          teams["team"][teamID]["net_points"].push(net_points)
          teams["team"][teamID]["quota"].push(quota)
          teams["team"][teamID]["pulled"].push(pulled)
          teams["team"][teamID]["par"].push(par)
          teams["team"][teamID]["tee"].push(tee)
          teams["team"][teamID]["otherquality"].push(otherquality)
          
        end
        self.set_skins(par,membID,group.points_birdie)
      end
    }
    
    teams["skins"] = @skins
    teams['skinswho'] =   @skinWho
    teams["teampot"] = teams["count"] *  group.round_dues ||= 0
    teams["skinspot"] = teams["count"] * group.skins_dues ||= 0
    
    if !teams["event"]["places"].nil?
      places = teams["event"]["places"]
    else
      places = ((teams["teams"] / 2.0) + 0.5 ).to_i 
      teams["event"]["places"] = places
    end
    
    teams['places'] = event.splitPot(teams["teampot"], places)  
    len = teams["team"].length
    #debugger
    j = 0
    for i in 1..len do
      if !teams["team"][i].nil?
        j += 1
        teams["teamtot"][j] = [teams["team"][i]["total"],i]
      end
    end
  
    teams["teamtot"].delete_at(0)
    if teams["count"] > 0
      teams = self.pay_teams(teams)
    end
    return teams
  end
  
  def self.pay_teams(teams)
    ts = teams['teamtot'].sort {|a,b| b<=>a}
    teams['teamtot'] = ts
    teamsToPay = teams["event"]["places"].to_i
    teamCount = teams["teamtot"].length
    teamtot_idx = 0
    pot_idx = 1
    while teamsToPay > 0
      thisAmount = teams['places'][pot_idx]
      thisTeam = teams["teamtot"][teamtot_idx][1]
      thisScore = teams["teamtot"][teamtot_idx][0]
      ties = 0
      tie_idx = teamtot_idx + 1
      while tie_idx < teamCount
        if teams["teamtot"][teamtot_idx][0] == teams["teamtot"][tie_idx][0]
          ties += 1
        end
        tie_idx += 1
      end
      if ties == 0
        teams["team"][thisTeam]["place"] = pot_idx
        teams["team"][thisTeam]["quality"] = thisAmount
        teams["team"][thisTeam]["comment"] = "Place: "+pot_idx.to_s+" Amount: " + thisAmount.to_s
        teamsToPay -= 1
        teamtot_idx += 1
        pot_idx += 1
      else
        tie_idx = pot_idx + 1
        teams["team"][thisTeam]["place"] = pot_idx
        while tie_idx <= teamsToPay
          thisAmount += teams['places'][tie_idx]
          tie_idx += 1
        end
        tie_amount = (thisAmount / (ties + 1).to_f).round_to(2)
        
        teams["team"][thisTeam]["quality"] = tie_amount
        teams["team"][thisTeam]["comment"] = "Its a tie for place "+pot_idx.to_s+" Amount: " + tie_amount.to_s
        for i in 1..ties
          tieTeam =  teams["teamtot"][teamtot_idx+i][1]
          teams["team"][tieTeam]["place"] = pot_idx
          teams["team"][tieTeam]["quality"] = tie_amount
          teams["team"][tieTeam]["comment"] = "Its a tie for place "+pot_idx.to_s+" Amount: " + tie_amount.to_s
        end
        teamsToPay -= 1 + ties
        teamtot_idx += 1 + ties
        pot_idx += 1 + ties
      end
    end
    return teams
  end
  
  def self.set_skins(par,membID,birdie)
    if par.length != 18
      return
    end
    for i in 0..17 do
      char = par[i..i]
      if char != '.' #no skin
        pts = char.to_i
        if pts >= birdie
          if @skins[i] == 0 #set skin
            @skins[i] = 1
            @skinType[i] = pts
            @skinWho[i] = membID
          elsif pts == @skinType[i] # skin cut
            @skins[i] += 1
            @skinWho[i] = 0
          elsif pts > @skinType[i] # took skin away with eagle or better
            @skins[i] = 1
            @skinType[i] = pts
            @skinWho[i] = membID
          end
        end
      end
    end
  end
  
  
  
    def self.calcPot(pot,places)
      money = Array.new(places)
      amt = 0
      case places.to_i
        when 6
          split = [0.0,0.30,0.20,0.16,0.13,0.11,0.1]
          for i in 1..split.length-1 do
            money[i] = (split[i] * pot).round
            amt += money[i]
          end
        when 5
          split = [0.0,0.36,0.24,0.17,0.13,0.1]
          for i in 1..split.length-1 do
            money[i] = (split[i] * pot).round
            amt += money[i]
          end
        when 4
          split = [0.0,0.43,0.26,0.18,0.13]
          for i in 1..split.length-1 do
            money[i] = (split[i] * pot).round
            amt += money[i]
          end
        when 3
          split = [0.0,0.5,0.3,0.2]
          for i in 1..split.length-1 do
            money[i] = (split[i] * pot).round
            amt += money[i]
          end
        when 2
          split = [0.0,0.6,0.4]
          for i in 1..split.length-1 do
            money[i] = (split[i] * pot).round
            amt += money[i]
          end
        else 
          money[1] = pot
          amt = pot
      end

      if (amt != pot) 
        dif = pot - amt
        money[1] += dif
      end
      money[0] = 0
      compPot = 0
      for i in 1..money.length-1 do
        compPot += money[i]
      end

      money[0] = compPot
      return(money) 
  end
  
  def splitPot(pot,places)
    if places > 5
      return split(pot,places)
    end
    arr = self.group.pot_splits
    splits = eval("[#{arr}]")
    split = splits[places - 1]
    money = []
    amt = 0
    for i in 0..split.length-1 do
      money[i] = ((split[i] / 100.0) * pot).round
      amt += money[i]
    end
    if (amt != pot) 
      dif = pot - amt
      money[0] += dif
    end
    money.insert(0,pot)
    return money
  end
  
  def split(pot,places)
      place = []
      place[0] = pot
      if places == 1
        place[1] = pot
        return place
      end
      if places == 2
        s40 = ((pot * 0.4)).round(0)
        s60 = pot - s40
        place[1] = s60
        place[2] = s40
      else
        places.downto(1) do |i|
            s40 = ((pot * 0.4) / i).round(0)
            puts s40
            i.downto(1) {|j| 
              place[j] = place[j].nil? ? s40 : place[j] + s40
            }
            pot -= s40 * i
            if i == 2
              s40 = ((pot * 0.4)).round(0)
              s60 = pot - s40
              place[1] += s60
              place[2] += s40
              break
            end
        end
      end
      return place
  end
  
  
  def set_session(params)
    evt = self.id.to_s
    group = self.group
    hash = {"id" => evt  , "attendees" => {}, "teams" => {}}
    params["round"]["memb"].each { |key,memb| 
      if memb != ""
        data = memb.split(":")
        team = data[1]
        memb = data[0]
        hash["attendees"][memb] = {
        "member_id" => memb.to_i,
        "team" => data[1].to_i,
        "plus_minus" => data[2].to_i,
        "quota" => data[3].to_i,
        "points_pulled" => data[4].to_i,
        "par" => data[5],
        "tee_id" => data[6].to_i,
        "gross_pulled" => data[7].to_i,
        "net_pulled" => data[8].to_i,
        "other_quality" => data[9].to_f,
        "limited" => data[10] == "true" ? true : false
      }
      if hash["attendees"][memb]["quota"] == 0
        m = Member.find(hash["attendees"][memb]["member_id"])
        hash["attendees"][memb]["quota"], hash["attendees"][memb]["limited"] = m.get_member_quota(hash["attendees"][memb]["tee_id"])
      end
      hash["attendees"][memb]["gross_pulled"] = hash["attendees"][memb]["quota"] + hash["attendees"][memb]["plus_minus"]
      hash["attendees"][memb]["net_pulled"] = hash["attendees"][memb]["gross_pulled"]
      hash["attendees"][memb]["points_pulled"] = hash["attendees"][memb]["gross_pulled"]
      if group["uses_round_limit"]
        if hash["attendees"][memb]["plus_minus"] > group["round_limit"]
          hash["attendees"][memb]["net_pulled"] = hash["attendees"][memb]["quota"] + group["round_limit"]
        else
          if hash["attendees"][memb]["plus_minus"] < (group["round_limit"] * -1)
            hash["attendees"][memb]["net_pulled"] = (hash["attendees"][memb]["quota"] - group["round_limit"] )
          end
        end
        if group["limit_gross_points"]
          hash["attendees"][memb]["points_pulled"] = hash["attendees"][memb]["net_pulled"]
        end
      end      
      if hash["attendees"][memb]["limited"] && group["uses_new_member_limit"]
        if hash["attendees"][memb]["plus_minus"] > group["new_member_limit"]
          hash["attendees"][memb]["net_pulled"] = hash["attendees"][memb]["quota"] + group["new_member_limit"]
        else
          if hash["attendees"][memb]["plus_minus"] < (group["new_member_limit"] * -1)
            hash["attendees"][memb]["net_pulled"] = (hash["attendees"][memb]["quota"] - group["new_member_limit"])
          end
        end
      end      
      if hash["teams"][team]
        hash["teams"][team] << memb
      else
        hash["teams"][team] = [memb]
      end
      end
    }
    return hash
  end
  
end
