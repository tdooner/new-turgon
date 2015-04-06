template '/etc/systemd/system/nginx.service' do
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
end

execute 'systemctl-daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

cert = ssl_certificate 'nginx-everything'

include_recipe 'nginx::source'

%w[
  /var/log/nginx
].each do |dir|
  directory dir do
    owner node['nginx']['user']
    group node['nginx']['user']
  end
end

nginx_site '000-default' do
  enable false
end

nginx_site 'http_file_server' do
  template 'http_file_server.vhost.erb'
end

chef_gem 'chef-rewind'
require 'chef/rewind'
unwind 'template[/etc/init.d/nginx]'
rewind 'template[nginx.conf]' do
  variables(
    ssl_cert_path: cert.chain_combined_path,
    ssl_key_path: cert.key_path
  )
end

rewind 'service[nginx]' do
  provider Chef::Provider::Service::Systemd
  action [:enable, :start]
end
