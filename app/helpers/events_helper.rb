module EventsHelper
  def group_courses
    courses = @current_group.courses
  end
  
  def round(float, decimal_places) # By Jagan Reddy
    exponent = decimal_places + 2
    @float = float*(10**exponent)
    @float = @float.round
    @float = @float / (10.0**exponent)
  end
  
  
  #Math.round(\([^\)]+\))
  #$1.round_to(0)
#  42 + 28 + 18 + 12
#  47 + 32 + 21
#  38 + 26 + 17 + 11 + 8

  def calcPot3(pot,places)
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
        split = [0.0,0.30,0.25,0.20,0.15,0.10]
        for i in 1..split.length-1 do
          money[i] = (split[i] * pot).round
          amt += money[i]
        end
      when 4
  			split = [0.0,0.40,0.30,0.20,0.10]
        for i in 1..split.length-1 do
          money[i] = (split[i] * pot).round
          amt += money[i]
        end
      when 3
  			split = [0.0,0.50,0.30,0.20]
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

  def calcPot2(pot,places)
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
        split = [0.0,0.38,0.26,0.17,0.11,0.08]
        for i in 1..split.length-1 do
          money[i] = (split[i] * pot).round
          amt += money[i]
        end
      when 4
  			split = [0.0,0.42,0.28,0.18,0.12]
        for i in 1..split.length-1 do
          money[i] = (split[i] * pot).round
          amt += money[i]
        end
      when 3
  			split = [0.0,0.47,0.32,0.21]
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
  splits = eval("[#{@current_group.pot_splits}]")
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
    def calcPot(pot,places)
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

  def split(pot,places)
      place = []
      if places == 1
        place[1] = pot
        return place, pot
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
       po = 0
       1.upto(places) {|i| po += place[i]}
      return place,po
  end


  
      
  def score_table
    score = ['Double Eagle',"Eagle","Birdie","Par","Bogie","Double Bogie"]
    result = "<table class=\"popup-list\">"
    result << "<tr><th>Clear &rarr;<br />Set &darr;</th>"
    1.upto(18) do |i|
      c = "<a id=\"clear_#{i}\" href=\"##{i}\" data-behavior=\"clear_radio\">#{i}</a>"
			#; setInOut('hole-#{i}')
      result << "<th>#{c}</th>"
    end
    result << "</tr>\n"
    score.each {|t|
      c = "<a id=\"set_#{t}\" href=\"##{t}\" data-behavior=\"set_radio\">#{t}</a>"
      result << "<tr><th>#{c}</th>"
      1.upto(18) do |i|
        e = "<input type=\"radio\" value=\"#{t}-#{i}\" id=\"#{t}-#{i}\" name=\"hole-#{i}\" data-behavior=\"set_score\" />"
        result << "<td>#{e}</td>"
      end
      result << "</tr>\n"
      }
      result << "</table>"
      return result
  end
  
  
  
end
