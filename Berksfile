source 'https://supermarket.chef.io'

Dir['cookbooks/*'].each do |cookbook_path|
  cookbook File.basename(cookbook_path), path: cookbook_path
end
