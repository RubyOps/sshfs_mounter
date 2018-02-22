require "sshfs_mount/version"
require "dry-configurable"
require "sys/filesystem"
include Sys

module Sshfs

  class MountPoints

    def initialize
      @mountpoints=[]
      @mounts={}

      Sys::Filesystem.mounts do |mount|
        @mountpoints << mount.mount_point
      end

      Sys::Filesystem.mounts do |mount|
        @mounts[mount.mount_point]={}
        @mounts[mount.mount_point][:name] = mount.name
        @mounts[mount.mount_point][:mount_options] = mount.options
      end
    end

    def printaj
      pp @mounts["/"][:mount_options]
      pp @mounts["/Users/nedim/datte"][:mount_options]
    end

    def is_mounted?(mount_points)
      @mountpoints.include?(mount_points)
    end

    def is_read_only?(mount_point)
      @mounts[mount_point][:mount_options].include?("read-only")
    end

  end

  class Mount
    extend Dry::Configurable

    setting :sshfs, reader: true do
      setting :mount_point
    end

    setting :binary, reader: true do
      setting :sshfs,  '/usr/bin/sshfs'
      setting :umount, '/bin/umount'
      setting :mount,  '/bin/mount'
      setting :e2fsck, '/sbin/e2fsck'
      setting :grep,   '/bin/grep'
    end

    setting :image, reader: true do
      setting :mount_point
      setting :name
    end

    setting :ssh, reader: true do
      setting :username
      setting :hostname
      setting :directory,   '/'
    end

    def self.printaj
      kakoje = MountPoints.new
      kakoje.printaj
    end

    def self.mount_sshfs
      ssh_remote_host = self.ssh.username.concat("@").concat(self.ssh.hostname).concat(":").concat(self.ssh.directory)
      system(binary.sshfs, ssh_remote_host, sshfs.mount_point) unless sshfs_is_mounted?
    end

    def self.unmount_sshfs
      system(binary.umount, sshfs.mount_point) if sshfs_is_mounted?
    end

    def self.mount_loop_image
      sshfs_mount_point_image_name = self.sshfs.mount_point.concat("/").concat(image.name)
      system(binary.mount, "-o loop", sshfs_mount_point_image_name, image.mount_point) if sshfs_is_mounted?
    end

    def self.unmount_loop_image
      system(binary.umount, image.mount_point) if loop_image_is_mounted?
    end

    def self.check_if_loop_image_file_system_is_clean?
      system(binary.e2fsck, "-f -n", "#{sshfs.mount_point}/#{image.name}") if sshfs_is_mounted? && !loop_image_is_mounted?
    end

    def self.fsck_and_repair_loop_image!
      system(binary.e2fsck, "-f -y", "#{sshfs.mount_point}/#{image.name}") if sshfs_is_mounted? && !loop_image_is_mounted?
    end

    def self.fsck_test_mount_or_repair
      if self.check_if_loop_image_file_system_is_clean? then
        self.mount_loop_image
      else
        self.fsck_and_repair_loop_image!
      end
    end

    def self.loop_image_is_mounted?
      if system(binary.grep, "-qs", image.mount_point, "/proc/mounts") == true
        return true
      else
        return false
      end
    end

    def self.loop_image_is_mounted_as_read_only?
      currently_mounted_points = MountPoints.new
      currently_mounted_points.is_read_only?(image.mount_point)
    end

    def self.sshfs_mounted_as_read_only?
      currently_mounted_points = MountPoints.new
      currently_mounted_points.is_read_only?(sshfs.mount_point)
    end

    def self.sshfs_is_mounted?
      currently_mounted_points = MountPoints.new
      currently_mounted_points.is_mounted?(sshfs.mount_point)
    end

    def self.inform_sshfs_mount_status
      puts "SSHFS is not mounted" unless sshfs_is_mounted?
      puts "SSHFS is indeed mounted" if sshfs_is_mounted?
    end

    def self.inform_image_mount_status
      puts "LOOP is not mounted" unless loop_image_is_mounted?
      puts "LOOP is indeed mounted" if loop_image_is_mounted?
    end

    def self.inform_is_image_mounted_as_read_only
      puts "LOOP is not mounted as read only" unless loop_image_is_mounted_as_read_only?
      puts "LOOP is indeed mounted as read only" if loop_image_is_mounted_as_read_only?
    end

    def self.image_file_system_check_status
      if !loop_image_is_mounted?
        puts "LOOP file system is ok" if check_if_loop_image_file_system_is_clean?
        puts "LOOP file system is not ok" unless check_if_loop_image_file_system_is_clean?
      end
    end

    def self.inform_mount_status
      inform_sshfs_mount_status
      inform_image_mount_status
      inform_is_image_mounted_as_read_only
      image_file_system_check_status
    end

  end
end
