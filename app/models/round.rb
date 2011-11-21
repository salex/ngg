class Round < ActiveRecord::Base
  belongs_to :member
  belongs_to :event
  belongs_to :tee
  validates_numericality_of :points_pulled
  validates_numericality_of :tee_id, :greater_than => 0
  
  validates_presence_of :tee_id
  
  
  def self.search(params)
    rounds = scoped  
    rounds = rounds.order("date DESC").where(:member_id => params[:member_id]) if params[:member_id]  
    rounds = rounds.order("team ASC").where(:event_id => params[:event_id]) if params[:event_id]  
    rounds = rounds.order("date DESC").where(:tee_id => params[:tee]) if params[:tee]  
    rounds  
    
  end
  
  def self.create_from_event(event,params,group)
    params["round"]["memb"].each do |key,val|
      memb = key
      rnd = self.new
      rnd.member_id = key.to_i
      rnd.event_id = event.id
      rnd.quota = params["round"]["quota"][memb]
      rnd.plus_minus = params["round"]["points"][memb]
      rnd.tee_id = params["round"]["tee"][memb]
      rnd.points_pulled = params["round"]["pulled"][memb]
      rnd.gross_pulled = params["round"]["pulled"][memb]
      net_limit = rnd.quota + params["round"]["net_points"][memb].to_i
      net_star = rnd.quota + params["round"]["starpoints"][memb].to_i
      logger.info "#{net_limit} #{net_star} #{group.uses_round_limit} #{group.limit_gross_points}"
      if group.uses_round_limit && group.limit_gross_points
        rnd.plus_minus = params["round"]["net_points"][memb]
        rnd.points_pulled = rnd.quota + rnd.plus_minus
      end
      rnd.net_pulled = [net_limit,net_star].min
      rnd.date = event.date
      rnd.team = params["round"]["team"][memb]
      rnd.round_quality = params["round"]["roundquality"][memb]
      rnd.skin_quality = params["round"]["skinquality"][memb]
      rnd.other_quality = params["round"]["otherquality"][memb]
      rnd.place =  params["round"]["place"][memb]
      rnd.par_in = params["round"]["par"][memb][0..8]
      rnd.par_out = params["round"]["par"][memb][9..17]
      rnd.save
      rnd.member.compute_tee_quota(rnd.tee_id)
      rnd.member.update_quota
    end
    event.teams = params["event"]["teams"]
    event.places = params["event"]["places"]
    event.attendees = params["team_members"]
    event.status = "Add"
  end
  
  def point_hash
    hash = {}
    hash["quota"] = self.quota
    hash["net_pulled"] = self.net_pulled
    hash["net_points"] = self.net_pulled - quota
    hash["gross_pulled"] = self.gross_pulled
    hash["gross_points"] = self.gross_pulled - quota
    test = hash["net_pulled"] - self.points_pulled 
    hash["starred"] = ((hash["net_pulled"] + test) != hash["gross_pulled"])
    return hash
  end
end
