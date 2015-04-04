execute 'systemctl-daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

user 'sabnzbd' do
  action :create
end

directory '/home/sabnzbd' do
  owner 'sabnzbd'
  group 'sabnzbd'
end

package 'par2'

easy_install_package 'cheetah' do
  version '2.4.4'
end

ark 'sabnzbd' do
  url node['sabnzbd']['url']
  checksum node['sabnzbd']['sha256sum']
  version node['sabnzbd']['version']
  owner node['sabnzbd']['user']
  group node['sabnzbd']['user']
end

# template '/etc/sabnzbd.ini' do
#   owner node['sabnzbd']['user']
#   group node['sabnzbd']['user']
#
#   notifies :restart, 'service[sabnzbd]'
# end

template '/etc/systemd/system/sabnzbd.service' do
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
end

service 'sabnzbd' do
  action [:enable, :start]
end
