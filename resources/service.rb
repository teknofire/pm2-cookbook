require 'json'

resource_name :pm2_service

property :user, String, default: 'root'
property :home, String
property :config, Hash, required: true
property :initsystem, String, default: ''
property :template_cookbook, String, default: 'node_pm2'
default_action :enable

action :enable do
  pm2_command "startup #{initsystem} -u #{new_resource.user}"
end

action :save do
  pm2_command 'save'
end

action :create do
  directory '/etc/pm2/conf.d' do
    recursive true
    owner 'root'
    group 'root'
    action :create
  end

  template service_config do
    source 'service.json.erb'
    cookbook new_resource.template_cookbook
    variables(config: new_resource.config)
    mode '0644'
  end
end

action :start do
  pm2_service new_resource.name do
    config(new_resource.config)
    action :create
  end

  cmd = "pm2 start #{service_config}"
  execute cmd do
    command cmd
    environment pm2_env
    notifies :save, "pm2_service[#{new_resource.name}]"
    not_if { service_online? }
  end
end

action :stop do
  cmd = "pm2 stop #{new_resource.name}"
  execute cmd do
    command cmd
    environment pm2_env
    notifies :save, "pm2_service[#{new_resource.name}]", :immediately
    only_if { service_online? }
  end
end

action :restart do
  pm2_command "restart #{new_resource.name}"
end

action :reload do
  pm2_command "reload #{new_resource.name}"
end

action :graceful_reload do
  cmd = "pm2 gracefulReload #{service_config}"
  execute cmd do
    command cmd
    environment pm2_env
    only_if { service_online? }
  end
end

action :start_or_restart do
  pm2_command("startOrRestart #{service_config}")
end

action :start_or_reload do
  pm2_command("startOrReload #{service_config}")
end

action :start_or_graceful_reload do
  pm2_command("startOrGracefulReload #{service_config}")
end

action_class do
  def pm2_command(pm2_command)
    cmd = "pm2 #{pm2_command}"
    execute cmd do
      command cmd
      environment pm2_env
    end
  end

  def service_available?
    service_config_exists? && service_online?
  end

  def service_config_exists?
    ::File.exist?(service_config)
  end

  def service_online?
    cmd = shell_out!('pm2 list',
                     user: new_resource.user,
                     environment: pm2_env)
    !cmd.stdout.match("#{new_resource.name}\s+|\s\w+\s|\s\w+\s|\s\w+\s|\sonline").nil?
  end

  def service_config
    "/etc/pm2/conf.d/#{new_resource.name}.json"
  end

  def pm2_home
    if new_resource.home.nil?
      "#{::Dir.home(new_resource.user)}/.pm2"
    elsif %r{/\.pm2/*$} =~ new_resource.home
      new_resource.home
    else
      "#{new_resource.home}/.pm2"
    end
  end

  def pm2_env
    { 'PM2_HOME' => pm2_home }
  end
end
