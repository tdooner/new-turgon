setup:
1. provision an ec2 machine
2. `curl -L https://www.chef.io/chef/install.sh | sudo bash`
3. `sudo mkdir /etc/chef`
4. `echo '{ "run_list": "role[mediacenter]" }' | sudo tee /etc/chef/solo.json`
5.

    ```
    cat <<EOF | sudo tee /etc/chef/solo.rb
    cookbook_path "/tmp/new-turgon/berks-cookbooks"
    role_path "/tmp/new-turgon/roles"
    json_attribs "/etc/chef/solo.json"
    EOF
    ```

6. `berks vendor && rsync -r ../new-turgon ubuntu@[ipaddress]:/tmp && ssh
   ubuntu@[ipaddress] sudo chef-solo`
