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
  $('[data-behavior="addMember"]').click (e) ->
    events.addMember(this,e)
  
  $('[data-behavior="setMember"]').click (e) ->
    events.setMember(this,e)
      
  $('[data-behavior="cancelAdd"]').click (e) ->
    events.cancelAdd(this,e)
  
  $('[data-behavior="setPoints"]').click (e) ->
    events.setPoints(this,e)
    
  $('[data-behavior="setTeam"]').click (e) ->
    events.setTeam(this,e)
    
  $('[data-behavior="setQuota"]').click (e) ->
    events.setQuota(this,e)
    
  $('[data-behavior="selectTee"]').change (e) ->
    events.selectTee(this,e)
    
  $('[data-behavior="clear_radio"]').click (e) ->
    events.clear_radio(this,e)

  $('[data-behavior="set_radio"]').click (e) ->
    events.set_radio(this,e)
    
  $('[data-behavior="set_score"]').click (e) ->
    setParInOut()

  $('#mask').click (e) ->
    events.cancelAdd(this,e)
  
  events =
    addMember: (o,e) ->
      anc = oid = o.id
      x = anc.split('_')
      membID = x[1]
      @membID = membID
      yy = '#mname_'+membID
      membname = $(yy).val()
      courseID = $('#event_course_id').val()

      maskpopup = $('#maskpopup')
      if !o.checked
        $('#h_memb').val('')
        pts = $('#mpts_'+ membID).html()
        msg = sortText($('#addStatus').html() + "#{pts} #{membname} removed \n")

        $('#addStatus').html(msg)
      
        $('#mpts_'+ membID).html("")
        $('#memb_'+ membID).val('')
        o.checked = false

        return(true)

      else
        $('#h_memb').val(o.id)
        $('#mname').html(membname)
        $('#quota').val("")

        setTeeOptions(membID,courseID,'tee')

      if $('#event_teams').attr("checked")
        el = $('select#team').get(0)
        was = el.selectedIndex
        el.selectedIndex = if was >= 0 then was else 0
        $('#s_team').val(el.value)
      else
        el = $('select#team').get(0)
        was = el.selectedIndex
        el.selectedIndex = was+1
        $('#s_team').val(el.value)
      

      $('#cb').val(oid)
      $("#points").val("") 
      $("#point_sel").get(0).selectedIndex = -1
      $("#point_selm").get(0).selectedIndex = -1
      for hole in [1..18]
        ca = $("input[name='hole-#{hole}']")
        for el in ca
          el.checked = false

      $("#parin").val(".........")
      $("#parout").val(".........")
      $("#pulled").val("")
      $("#starpoints").val("")
      $("#otherquality").val("")
      
      $("#net_points").val("")
      $("#set").attr("disabled", true)
    
      events.showDialog('#maskpopup')
      return(true)
  
    setMember: (o,e) ->
      team = $('#s_team').val()
      points = $('#points').val()
      quota = $('#quota').val()
      pulled = $('#pulled').val()
      par = $('#parin').val() + $('#parout').val()
      teeSelect = $('#tee')
      tee = membOpt[teeSelect.val()] # get array elem
      teeID = tee.tee
      limited = tee.limited
      starpoints = $('#starpoints').val()
      net_points = $('#net_points').val()
      otherquality = $('#otherquality').val()
      
      membID = @membID
      list =  membID + ":" + team + ":" +  points + ":" +  quota + ":" +  pulled + ":" +  par + ":" +  teeID + ":" +  starpoints + ":" +  net_points + ":" +  otherquality + ":" +  limited
      ihtml =  "T" + team + ":" + points
      $('#memb_'+ membID).val(list)
      $('#mpts_'+ membID).html(ihtml)
      #$('addround').className = "app-form"
      #$('member-list').style.display = "block"
      msg = sortText($('#addStatus').html() + "T#{team} #{$('#mname_'+@membID).val()} (#{points}) added\n")
      $('#addStatus').html(msg)

      $('#mask').hide()
      $('.window').hide()
    
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
        
    selectTee: (o,e) ->
      teeSelect = $('#tee')
      tee = membOpt[teeSelect.val()] # get array elem
      setQuota(tee)
      
    setPoints: (o,e) ->
      set_points(o.value)
    
    setTeam:  (o,e) ->
      set_team(o.value)
    
    cancelAdd: (o,e) ->
      msg = sortText($('#addStatus').html() + "ZZ #{$('#mname_'+@membID).val()} canceled \n")
      
      $('#addStatus').html(msg)
      $('#addmemb_'+ @membID).attr("checked",false)
      $('#mask').hide()
      $('.window').hide()
         
      
    showDialog:  (id) ->  
      #Get the container height and width
      maskHeight = $('#container').height()
      maskWidth = $('#container').width()
      winH = $(window).height()
      winW = $(window).width()
      #Set heigth and width to mask to fill up the content div
      $('#mask').css({width: winW, height: maskHeight}) 
      $('#mask').fadeIn(1000) 
      $('#mask').fadeTo("slow",0.7) 
      #Get the window height and width
      #Set the popup window to center
      $(id).css('top',  winH/2-$(id).height()/2)
      $(id).css('left', maskWidth/2-$(id).width()/2)
      #transition effect
      $(id).fadeIn(500)
      
        
  set_team = (team) ->
    $('#s_team').val(team)
  
  set_points = (points) ->
    $('#points').val(points)
    $("#set").attr("disabled", false)
    calcPoints()
        
  setQuota = (teeOpt) ->
    $('#quota').val(teeOpt.quota)
    $('#limited').html(teeOpt.star)
    calcPoints()

  setTeeOptions = (memberID,courseID,elem) ->
    $.get '/members/' +memberID + '/teeopt?course='+courseID,
    {"shit": "brains"},
    (data) ->
      obj = jQuery.parseJSON(data)
      teeSelect = $('#'+elem)
      teeSelect.html(obj.teeopt)
      membOpt = obj.membopt
      window["membOpt"] = membOpt
      window["groupOpt"] = obj.group
      teeOpt = membOpt[teeSelect.val()] # get array elem
      setQuota(teeOpt)
      return(true)
      
 
      
  setParInOut = ->
    #scoreValues = [5,4,3,2,1,0]
    scoreValues = groupOpt["scoreValues"]
    
    scoreTypes = ["Double Eagle","Eagle","Birdie","Par","Bogie","Double Bogie"]
    parInOut = [".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",]
    for i in [1..18]
      ca = $("input[name='hole-#{i}']:checked")
      if ca.length is 1
        type_hole = ca.val().split('-')
        type = type_hole[0]
        hole = type_hole[1]
        pos = jQuery.inArray(type,scoreTypes)
        if pos >= 0
          parInOut[i] = scoreValues[pos]
      
    parString = ""
    for i in [1..18]
      parString += parInOut[i]
      
    $('#parin').val(parString.slice(0,9))
    $('#parout').val(parString.slice(9))
    return true
    
  calcPoints = ->
    teeSelect = $('#tee')
    tee = membOpt[teeSelect.val()] # get array elem
    qq = Number($('#quota').val())
    isLimited = tee.limited
    points =  Number($('#points').val())
    pulled = qq + points
    $('#pulled').val(pulled)
    $('#starpoints').val(points)
    $('#net_points').val(points)
    if groupOpt["uses_round_limit"]
      if points > groupOpt["round_limit"]
        $('#starpoints').val(groupOpt["round_limit"])
        $('#net_points').val(groupOpt["round_limit"])
      else
        if points < (groupOpt["round_limit"] * -1)
          $('#starpoints').val((groupOpt["round_limit"] * -1))
          $('#net_points').val((groupOpt["round_limit"] * -1))
    if isLimited
      if points > groupOpt["new_member_limit"]
        $('#starpoints').val(groupOpt["new_member_limit"])
      else
        if points < (groupOpt["new_member_limit"] * -1)
          $('#starpoints').val((groupOpt["new_member_limit"] * -1))
          
  sortText = (s) ->
    temp = new Array()
    temp = s.split('\n')
    temp.sort()
    result = ""
    for i in temp
      result += i + "\n" if i isnt ""
    return result

  

