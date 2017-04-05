#############################################################################
# Cookbook Name:: sudo
# Recipe:: cloudera-scm
#
# Copyright 2017, Pentaho, A Hitachi Group Company
#
# All rights reserved - Do Not Redistribute
#############################################################################
template '/etc/sudoers' do
  source 'cloudera_scm.erb'
  owner 'root'
  group 'root'
  mode '0440'
end

if `cat /etc/pam.d/su |grep 'session         required        pam_limits.so'`.empty?
  ruby_block "insert_su_pam_limits" do
    block do
      line = 'session         required        pam_limits.so'
      file = Chef::Util::FileEdit.new("/etc/pam.d/su")
      file.insert_line_if_no_match(/#{line}/, line)
      file.write_file
    end
  end
end
