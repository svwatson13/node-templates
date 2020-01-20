#
# Cookbook:: node_sample
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

#imports
include_recipe 'apt'
include_recipe 'nodejs'


#packges apt-get
apt_update 'updates_sources' do
  action :update
end

# resource services
#package 'npm'
package 'nginx'

nodejs_npm 'pm2'

service 'nginx' do
  action :start
end

service 'nginx' do
  action :enable
end

# resource template
template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  variables(proxy_port: node['nginx']['proxy_port'])
  notifies :restart, 'service[nginx]'
end

# resource link
link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
  notifies :restart, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/default'do
  action :delete
  notifies :restart, 'service[nginx]'
end
