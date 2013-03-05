module ApplicationHelper
  def flash_messages
    result =""
      %w(notice warning error alert).each do |msg|
        result <<  content_tag(:div, content_tag(:p, flash[msg.to_sym]),
          :class => "message #{msg}") unless flash[msg.to_sym].blank?
      end
      result.html_safe
  end
  
  def menuBar
     menu = '<span class="navspan">'
     items = {:home => nil, :members => nil,:events => nil,:lists => nil,:login => nil,:logout => nil, :rounds => nil, :courses => nil, :photos => nil, :admin => nil}
     case params[:controller]
       when 'members'
         items[:members] = 'class="selected"'
       when 'events'
         items[:events] = 'class="selected"'
       when 'list'
         items[:list] = 'class="selected"'
       when 'login'
         items[:login] = 'class="selected"'
       when 'logout'
         items[:logout] = 'class="selected"'
       when 'rounds'
         items[:rounds] = 'class="selected"'
       when 'courses'
         items[:courses] = 'class="selected"'
       when 'groups'
         items[:admin] = 'class="selected"'
       else
         items[:home] = 'class="selected"'
     end
    if @current_group 
      menu << "<a href=\"#{root_path}\" #{items[:home]} >Home</a>"
      menu << "<a href=\"#{members_path}\" #{items[:members]} >Members</a>"
      menu << "<a href=\"#{events_path}\" #{items[:events]} >Events</a>"
      menu << "<a href=\"#{courses_path}\" #{items[:courses]} >Courses</a>"
      if !items[:rounds].nil?
        menu << "<a href=\"#{rounds_path}\" #{items[:rounds]} >Rounds</a>"
        
      end
        if !current_user.nil?
          if can? :invite, Member
            menu << "<a href=\"#{group_path @current_group }\" #{items[:admin]} >Admin</a>"
          end
          menu << "<a class=\"user\" href=\"#{member_path(current_user.member_id)}\">#{current_user.name}</a>"
        end
        
    else 
      menu << "<a href=\"#{root_path}\" #{items[:home]} >Home</a>"
      menu << "<a href=\"#{groups_path}\" #{items[:members]} >Groups</a>"
      menu << "<a href=\"#{courses_path}\" #{items[:lists]} >Courses</a>"
      
    end 
    menu << '</span>'
    
    return menu
  end
  
  def get_colsize(cnt,col)
    if cnt == 0
      return 1
    end
    if col > cnt then  col = cnt end
    if cnt != 0 and cnt != nil and col > 0
      colsize = cnt.div(col)
      colsize = cnt.modulo(colsize) != 0 ? colsize + 1: colsize
      if col != 1
        if colsize < 2
          colsize += 1
        end
      end
    else
      colsize = cnt
    end
    return colsize
  end
  
  def float_table_columns(columns,max_number_columns,header="",alt="",divclass="", tableclass="")
    colsize = get_colsize(columns.length,max_number_columns)
    trclass = alt.blank? ? "" : "class=\"#{alt}\""
    tables = ""
    cnt = 0
    altswitch = false
    columns.each {|tr|
      altswitch = !altswitch
      if cnt.modulo(colsize) == 0
        altswitch = true
        tables << "<div class=\"#{divclass}\" style=\"padding-right:4px\"><table class=\"#{tableclass}\">"
        if !header.blank?
          tables << header
        end
      end
      if altswitch
        tables << "<tr #{trclass}>"
      else
        tables << "<tr>"
      end
      tables << tr
      tables << "</tr>"
      cnt += 1
      if cnt.modulo(colsize) == 0
        tables << '</table></div>' +"\n"
      end
      
    }
    if cnt.modulo(colsize) != 0
      tables << '</table></div>'
    end
    tables << '<div style="clear:both"></div>'
    return tables
  end
  
  def tee_options
    tee_options = [["Select Tee",""],["P(ro/Championship/Tips" , "P"],["B(ack/Members" ,"B"],["M(iddle/Senior" , "M"],["F(orward/Ladies/SuperSenior" , "F"],["C(omposite/Special/Local" , "C"]]
  end
  
  def disp_header(title,links = "",back = true)
    header = '<div id="header">'
    header += '<div class="title">'+title+'</div>'
    if links != ""
      header += '<div class="links">'+links+'</div>'
    end
    if back
      header += '<div class="back links">'+'<a href="javascript:history.go(-1)">&larr;Back</a>'+'</div>'
    end
    header += '<div style="clear:both"></div></div>'
  end
  
  def truncate_text(text,length = 40, where = "end")
    if text.nil?
      return text
    end
    text_length = text.length
    if text_length <= length
      return text
    end
    if where.downcase == "end"
      return( text.first(length)+"&hellip;")
    elsif where.downcase == "begin"
      return( text.last(length)+"&hellip;")
    else
      return(text.first(length / 2)+"&hellip;"+ text.last(length / 2))
    end
  end
  
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(:autolink => true, :hard_wrap => true, :fenced_code_blocks => true, :lax_spacing => true)
    markdown = Redcarpet::Markdown.new(renderer)
    
    
    # options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis, :fenced_code, :gh_blockcode]
    # html = Redcarpet.new(text, *options).to_html
    return "<div class=\"markdown\">#{markdown.render(text).html_safe}</div>".html_safe
  end
  
  def format_money(value,dollar=false)
    if value.nil?
      return 
    end
    if dollar
      result = number_to_currency(value)
    else
      result = ("%0.2f" % value)
    end
  end
  
  
end
