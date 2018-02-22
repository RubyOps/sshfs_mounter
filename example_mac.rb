#!/usr/bin/env rvm-auto-ruby

require "bundler/setup"
require "sshfs_mount"

Sshfs::Mount.configure do |config|
  config.binary.sshfs       = "/usr/local/bin/sshfs"
  config.binary.grep        = "/usr/bin/grep"
  config.sshfs.mount_point  = "/Users/username/datte"
  config.image.mount_point  = "loop_image_mount_point"
  config.image.name         = "loop_image_name"
  config.ssh.username       = "nedim"
  config.ssh.hostname       = "FQDN"
  config.ssh.directory      = "/home/username/folder"
end

#Sshfs::Mount.mount_sshfs
#puts Sshfs::Mount.sshfs_mounted_as_read_only?
#puts Sshfs::Mount.loop_image_is_mounted_as_read_only?
#puts Sshfs::Mount.sshfs_is_mounted?
puts Sshfs::Mount.ssh_remote_host
puts Sshfs::Mount.printaj_sshfs
#
#Sshfs::Mount.get_sshfs_mount_point_info
#
#puts Sshfs::Mount.get_mount_points
#puts "IS SSHFS MOUNTED? " + Sshfs::Mount.sshfs_is_mounted?.to_s
#puts Sshfs::Mount.loop_image_is_mounted?
#puts Sshfs::Mount.loop_image_is_mounted_as_read_only?
#puts Sshfs::Mount.fsck_test_mount_or_repair
