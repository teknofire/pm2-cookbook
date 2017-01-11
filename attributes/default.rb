node.default['pm2']['version'] = 'latest'

if node['platform_family'] == 'debian'
  default['nodejs']['repo'] = 'https://deb.nodesource.com/node_6.x/'
end
