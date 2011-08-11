class Round < ActiveRecord::Base
  belongs_to :member
  belongs_to :event
  belongs_to :tee
  
  
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
      rnd.points_pulled = params["round"]["pulled"][memb]
      rnd.gross_pulled = params["round"]["pulled"][memb]
      rnd.net_pulled = rnd.quota + params["round"]["net_points"][memb].to_i
    
      if group.uses_round_limit
        rnd.plus_minus = params["round"]["starpoints"][memb]
        rnd.points_pulled = rnd.quota + rnd.plus_minus
      end
      rnd.date = event.date
      rnd.tee_id = params["round"]["tee"][memb]
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
    event.attendees = params["team_members"]
    event.status = "Add"
  end
  
end
