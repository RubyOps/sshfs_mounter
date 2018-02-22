#!/usr/bin/env rvm-auto-ruby

require "bundler/setup"
require "sshfs_mount"

Sshfs::Mount.configure do |config|
  config.binary.grep        = "/bin/grep"
  config.sshfs.mount_point  = "sshfs_mount_point"
  config.image.mount_point  = "loop_image_mount_point"
  config.image.name         = "loop_image_name"
  config.ssh.username       = "sshfs_username"
  config.ssh.hostname       = "sshfs_hostname"
end

puts Sshfs::Mount.mount_sshfs
puts Sshfs::Mount.loop_image_is_mounted?
puts Sshfs::Mount.sshfs_is_mounted?
puts Sshfs::Mount.loop_image_is_mounted_as_read_only?
puts Sshfs::Mount.fsck_test_mount_or_repair
