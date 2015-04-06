user node['sickbeard']['user']

directory "/home/#{node['sickbeard']['user']}" do
  user node['sickbeard']['user']
  group node['sickbeard']['user']
end

ark 'sickbeard' do
  version 'build-507'
  checksum 'eaf95ac78e065f6dd8128098158b38674479b721d95d937fe7adb892932e9101'
  url 'https://github.com/midgetspy/Sick-Beard/archive/build-507.tar.gz'
  owner node['sickbeard']['user']
  group node['sickbeard']['user']

  notifies :run, 'execute[fix-sickbeard-webroot]'
end

template '/etc/systemd/system/sickbeard.service' do
  notifies :run, 'execute[systemctl-daemon-reload]', :immediately
end

execute 'fix-sickbeard-webroot' do
  command "sed -ie '/web_root =/c\web_root = /sickbeard' /usr/local/sickbeard/config.ini"
  not_if "grep -E 'web_root.*sickbeard' /usr/local/sickbeard/config.ini"

  notifies :restart, 'service[sickbeard]'
end

service 'sickbeard' do
  action [:enable, :start]
end

execute 'systemctl-daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

include_recipe 'sickbeard::_nginx'
