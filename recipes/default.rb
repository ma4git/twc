#
# Cookbook Name:: twc
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
package 'epel-release'
package 'nginx'

#template '/etc/nginx/nginx.conf' do
#  source 'nginx.conf.erb'
#end

template '/etc/nginx/conf.d/default.conf' do
  source 'etc.nginx.conf.d.default.erb'
	notifies :reload, 'service[nginx]', :immediately
end

service 'nginx' do
	supports :restart => true, :reload => true
        action [:enable, :start]
	subscribes :reload, 'template[/etc/nginx/conf.d/default.conf]', :immediately
end

