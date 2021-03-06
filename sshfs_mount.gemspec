
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sshfs_mount/version"

Gem::Specification.new do |spec|
  spec.name          = "sshfs_mount"
  spec.version       = SshfsMount::VERSION
  spec.authors       = ["Nedim Hadzimahmutovic"]
  spec.email         = ["h.nedim@gmail.com"]

  spec.summary       = %q{SshfsMount is a gem to mount remote direcotries via sshfs.}
  spec.description   = %q{SshfsMount is a gem to mount remote direcotries via sshfs..}
  spec.homepage      = "https://github.com/RubyOps/sshfs_mounter"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-configurable", "~> 0.7"
  spec.add_dependency "sys-filesystem", "~> 1.1.9"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
