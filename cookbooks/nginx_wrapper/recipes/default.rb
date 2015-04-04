include_recipe 'nginx::source'

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
