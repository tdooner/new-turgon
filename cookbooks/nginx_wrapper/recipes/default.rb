template '/etc/systemd/system/nginx.service' do
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
end

execute 'systemctl-daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

include_recipe 'nginx::source'

%w[
  /var/log/nginx
  /var/run/nginx
].each do |dir|
  directory dir do
    owner node['nginx']['user']
    group node['nginx']['user']
  end
end

cert = ssl_certificate 'nginx-everything'
template '/etc/nginx/nginx.conf' do
  notifies :reload, 'service[nginx]'
  variables(
    ssl_cert_path: cert.chain_combined_path,
    ssl_key_path: cert.key_path
  )
end

nginx_site '000-default' do
  enable false
end

chef_gem 'chef-rewind'
require 'chef/rewind'
rewind 'service[nginx]' do
  provider Chef::Provider::Service::Systemd
  action [:enable, :start]
end
