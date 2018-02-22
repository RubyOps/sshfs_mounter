require "bundler/setup"
require "sshfs_mount"

RSpec.describe SshfsMount do
  it "has a version number" do
    expect(SshfsMount::VERSION).not_to be nil
  end

  it "checks is sshfs is mounted or not" do
    expect(Sshfs::Mount.sshfs_is_mounted?).to be(true).or be(false)
  end

  it "checks is loop image is mounted as read only" do
    expect(Sshfs::Mount.loop_image_is_mounted_as_read_only?).to be(true).or be(false)
  end

  it "checks is loop image is mounted or not" do
    expect(Sshfs::Mount.loop_image_is_mounted?).to be(true).or be(false)
  end
end
