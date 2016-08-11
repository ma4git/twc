#
# Cookbook Name:: twc
# Recipe:: default
#
# Copyright (c) 2016 Masood Ahmed, All Rights Reserved.
#
# This chef recipe installs nginx if it is not already installed, enables and start it, and set the desired configuration.
# The epel-release package is required to install nginx.
#
# The commented lines below were part of the testing process and should be left commented out.
#
package 'epel-release'
package 'nginx'

execute 'set_ephemeral_port_range' do
  command 'echo 20000 64000 > /proc/sys/net/ipv4/ip_local_port_range'
  action :nothing
end

# If /etc/nginx/conf.d/default.conf is out of policy, replace with the template copy and reload nginx.
template '/etc/nginx/conf.d/default.conf' do
#  notifies :run, 'execute[set_ephemeral_port_range]', :immediately
  source 'etc.nginx.conf.d.default.erb'
#  notifies :reload, 'service[nginx]', :immediately
end

# 
service 'nginx' do
  supports :restart => true, :reload => true
  notifies :run, 'execute[set_ephemeral_port_range]', :immediately
  action [:enable, :start]
  subscribes :reload, 'template[/etc/nginx/conf.d/default.conf]', :immediately
end

