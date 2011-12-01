# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http:#jashkenas.github.com/coffee-script/

$(document).ready ->

  membId = undefined
  $('.window').hide()
  ###
  Behaviors Most behaviors responding to an event will call
  a function in events
  ###
    
  $('[data-behavior="set_plus_minus"]').change (e) ->
    events.set_plus_minus(this,e)
    
    
  $('[data-behavior="select_tee"]').change (e) ->
    events.select_tee(this,e)
    
  $('[data-behavior="clear_radio"]').click (e) ->
    events.clear_radio(this,e)

  $('[data-behavior="set_radio"]').click (e) ->
    events.set_radio(this,e)
    
  $('[data-behavior="set_score"]').click (e) ->
    setParInOut()

  $('[data-behavior="set_hole"]').click (e) ->
    set_hole(this,false)
    
  $('[data-behavior="validate"]').submit (e) ->
    events.validate_stuff(this,e)

  $('[data-behavior="clear_hole"]').click (e) ->
    clear_hole(this)
    
  $('#mask').click (e) ->
    events.cancelAdd(this,e)
  
  events =
    set_radio: (o,e) ->
      type = o.id.replace("set_","")
      i = 1
      set = true
      if $('#'+type+"-"+i).is(':checked')
        set = false 
      for i in [1..18]
        $('#'+type+"-"+i).attr('checked',set)
      setParInOut()
      
    clear_radio: (o,e) ->
      hole = o.id.replace("clear_","")
      ca = $("input[name='hole-#{hole}']")
      for el in ca
        el.checked = false
       
    get_key: (o) ->
      chunks = o.id.split("_")
      key = chunks[0]+"_"+chunks[1]

          
    select_tee: (o,e) ->
      #data = o.options(o.selectedIndex).dataset.quota
      key = events.get_key(o)
      #data_chunks = data.split(":")
      data = events.getTee(key)
      quota_id = key+"_quota"
      $("#"+quota_id).val(data["quota"])
      pm = $("#"+key+"_plus_minus")
      if pm.val() != ""
        events.calc_points(key)
      
    setPoints: (o,e) ->
      set_points(o.value)
      
      
    getTee: (key) ->
      sel = $("#"+key+"_tee").get(0)
      data = sel.options(sel.selectedIndex).dataset.quota.split(":")
      h = {"quota" : Number(data[0]),"star" : data[1], "limit"  : Number(data[2])}
      
      
    set_plus_minus: (o,e) ->
      #if o.checked
      key = events.get_key(o)
      $("#"+key+"_plus_minus").val(o.value)
      events.calc_points(key)
        
      
    calc_points: (key) ->
      data = events.getTee(key)
      pm = Number($("#"+key+"_plus_minus").val())
      gross = data["quota"] + pm
      net = gross
      netpm = pm
      if pm > data["limit"]
        netpm = data["limit"]
        net = data["quota"] + netpm
      if pm < (data["limit"] * -1)
        netpm = data["limit"] * -1
        net = data["quota"] + netpm
      $("#"+key+"_gross").val(gross)
      $("#"+key+"_net").val(net)
      $("#"+key+"_netpm").val(netpm)
      calc_team_results()
      
      
    validate_stuff: (o,e) ->
      members = $(".members")
      for m in members
        key = "add_"+m.value
        gross = $("#"+key+"_gross").val()
        if gross == ""
          errdiv = $("#error_explanation")
          $("#validation_errors").html("Score has not been entered for member(s)")
          errdiv.show()
          return(false)
        disabled = $(".disabled")
        for field in disabled
          field.disabled = false
      return( true)
      
        
  sort_num = (a,b) ->
    b - a
    
  calc_team_results = ->
    teams = $(".teams")
    members = $(".members")
    cnt = members.length
    pay_places = Number($("#event_places").val())
    
    team_scores = {}
    for t in teams
      team_scores[t.value] = 0
    for m in members
      key = "add_"+m.value
      pm = $("#"+key+"_netpm").val()
      cnt -= 1 if pm != ""
      team = $("#"+key+"_team").val()
      team_scores[team] += Number(pm)
    if cnt == 0
      $("#create_button").attr("disabled",false)
    places = []
    for key, value of team_scores
      places[places.length] = value
    places.sort(sort_num)
    place_split = get_place_splits(places)
    for key, value of team_scores
      place = places.indexOf(value) + 1
      if place > pay_places
        won = "" 
        $("#"+"team_share_"+key).val(0)    
      else 
        $("#"+"team_share_"+key).val(place_split[place]) 
        size = $("#"+"team_size_"+key).val()
        each = roundQuarter(place_split[place] / size)
        won = "- Team: $#{place_split[place]} Each: $#{each}"
          
      $("#"+"team_scores_"+key).html("+-Score: #{value} - Place: #{place} #{won}")
      $("#"+"team_place_"+key).val(place)
      $("#"+"team_score_"+key).val(value)    

  get_place_splits = (team_places) ->
    # get from dom
    pot = jQuery.parseJSON($('#team_team_pot').val())
    places = $('#event_places').val()
    
    #local
    place_cnt = {1 : 0}
    place_split = [0]
    score = team_places[0]
    team = 1
    paid = 0
    for team_score in team_places
      if team_score == score
        place_cnt[team]++
      else
        team++
        place_cnt[team] = 1
        score = team_score
    for place, ties of place_cnt
      if paid < places      
        sum = 0
        from = paid + 1
        to = from + ties - 1
        if to > places
          to = places 
        for i in [from..to]
          sum += pot[i]
          place_split[i] = 0
        place_split[from] = roundQuarter(sum / ties)
        paid += ties
      else
        #place_split[place] = 0
    return place_split

        
  set_hole = (hole,down) ->
    hole_id = hole.id
    set_id = hole_id + "_s"
    hide_id = hole_id
    key = events.get_key(hole)
    downa = $('#'+key+"_up_0")
    down = downa.get(0).checked
    #hide_id = hole_id + "_hole"
    curr_val = hole.value #$('#'+hide_id).val()
    new_val = "."
    if down
      switch curr_val
        when '.' then new_val = 'P'
        when 'P' then new_val = 'O'
        when 'O' then new_val = 'D'
        when 'D' then new_val = 'A'
        when 'A' then new_val = 'E'
        when 'E' then new_val = 'B'
        when 'B' then new_val = '.'
        else new_val = "?"
    else
      switch curr_val
        when '.' then new_val = 'B'
        when 'B' then new_val = 'E'
        when 'E' then new_val = 'A'
        when 'A' then new_val = 'D'
        when 'D' then new_val = 'O'
        when 'O' then new_val = 'P'
        when 'P' then new_val = '.'
        else new_val = "?"
    
    $('#'+set_id).html(new_val)
    #$('#'+hide_id).val(new_val)
    hole.value = new_val
    if hole.value == "."
      hole.checked = false
    else
      hole.checked = true
      # body...
    check_holes(hole_id)
    
  check_holes = (hole_id) ->
    parts = hole_id.split("_")
    hole = parts[2]
    the_holes = $(".hole-#{hole}")
    a = e = b = 0
    for ahole in the_holes
      if ahole.value == "A" then a++
      if ahole.value == "E" then e++
      if ahole.value == "B" then b++
    if a == 1
      mark_hole(the_holes,hole,"A")
    else if e == 1
        mark_hole(the_holes,hole,"E")
    else if b == 1
        mark_hole(the_holes,hole,"B")
    else
      mark_hole(the_holes,hole,".")
      
  mark_hole = (the_holes,hole,what) ->
    for ahole in the_holes
      key = events.get_key(ahole)
      if (ahole.value == what)
        $("##{key}"+"_"+hole+"_s").attr("class","lboxg")
      if (ahole.value != what)
        patt1 = new RegExp("(A|E|B)")
        if (patt1.test(ahole.value))
          $("##{key}"+"_"+hole+"_s").attr("class","lboxr")
        else
          $("##{key}"+"_"+hole+"_s").attr("class","lbox")
  
  clear_hole = (hole) ->
    hole_id = hole.id
    hide_id = hole_id.replace("_s","")
    $('#'+hole_id).html(".")
    o = $('#'+hide_id)
    $('#'+hide_id).val(".")
    $('#'+hide_id).attr("checked",false)
    
    check_holes(hole_id)
    
  sortText = (s) ->
    temp = new Array()
    temp = s.split('\n')
    temp.sort()
    result = ""
    for i in temp
      result += i + "\n" if i isnt ""
    return result
    
  roundQuarter = (num) ->
    x = (num*4)  >> 0
    y = x / 4

  

