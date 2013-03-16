namespace :nginx do
  desc "Install latest stable release of nginx"
  task :install, roles: :web do
    run "#{sudo} brew update nginx"
  end
  after "deploy:install", "nginx:install"

  desc "Setup nginx configuration for this application"
  task :setup, roles: :web do
    template "nginx_unicorn.erb", "/tmp/nginx_conf"
    run "#{sudo} mv /tmp/nginx_conf /usr/local/etc/nginx/sites-enabled/#{application}"
    reload
  end
  after "deploy:setup", "nginx:setup"
  
  %w[reopen stop reload].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} nginx -s #{command}"
    end
  end
end
