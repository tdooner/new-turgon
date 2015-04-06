default['nginx']['version'] = '1.7.11'
default['nginx']['source']['version'] = node['nginx']['version']
default['nginx']['source']['checksum'] = 'dad9d740210e638bfd480536910083ed13f04c04775eedf877984e1c61a69695'

default['nginx']['conf_cookbook'] = 'nginx_wrapper'
default['nginx']['source']['prefix'] = "/opt/nginx-#{node['nginx']['source']['version']}"
default['nginx']['source']['url'] = "http://nginx.org/download/nginx-#{node['nginx']['source']['version']}.tar.gz"
default['nginx']['install_method'] = 'source'
default['nginx']['source']['modules'] = %w[
  nginx::http_spdy_module
  nginx::http_gzip_static_module
  nginx::http_ssl_module
]
default['nginx']['init_style'] = 'sysv' # the default if not runit
default['nginx']['default_site_enabled'] = false

# TODO: separate this into a wrapper cookbook:
default['ssl_certificate']['user'] = node['nginx']['user']
