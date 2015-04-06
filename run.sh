#!/usr/bin/env bash

echo "Server IP?: "
read ip

echo 'Installing chef...'
ssh ubuntu@$ip 'if [ ! $(which chef-solo) ]; then curl -L https://www.chef.io/chef/install.sh | sudo bash; fi'

echo 'Installing /etc/chef/solo.rb'
cat <<EOF | ssh ubuntu@$ip 'sudo mkdir -p /etc/chef && sudo tee /etc/chef/solo.rb >/dev/null'
cookbook_path "/tmp/new-turgon/berks-cookbooks"
role_path "/tmp/new-turgon/roles"
json_attribs "/etc/chef/solo.json"
EOF

echo 'Installing /etc/chef/solo.json'
echo '{ "run_list": "role[mediacenter]" }' | ssh ubuntu@$ip 'sudo tee /etc/chef/solo.json >/dev/null'

echo 'Deploying...'
berks vendor >/dev/null
rsync -r ../new-turgon ubuntu@$ip:/tmp
ssh ubuntu@$ip 'sudo chef-solo'
