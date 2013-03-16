  
  def prod_smtp_settings
    settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => 'golfgaggle.com',
      :user_name            => 'golfgaggle',
      :password             => 'gm.gg.1710',
      :authentication       => 'plain',
      :enable_starttls_auto => true  
    }
    return settings
  end
  
  def dev_smtp_settings
    settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => 'golfgaggle.com',
      :user_name            => 'golfgaggle@gmail.com',
      :password             => 'gm.gg.1710',
      :authentication       => 'plain',
      :enable_starttls_auto => true  
    }
    return settings
  end
  
