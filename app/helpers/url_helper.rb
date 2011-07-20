module UrlHelper
  
  def with_group(group)
    group = (group || "")
    group += "." unless group.empty?
    u = [group, request.domain].join
    return u
  end

  def url_for(options = nil)
    if options.kind_of?(Hash) && options.has_key?(:group)
      options[:host] = with_group(options.delete(:group))
    end
    super
  end
  def set_mailer_url_options
    ActionMailer::Base.default_url_options[:host] = with_group(request.subdomains.first)
  end
end
