# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pakket_hub_core/version'

Gem::Specification.new do |spec|
  spec.name          = "pakket_hub_core"
  spec.version       = PakketHub::VERSION
  spec.authors       = ["Grady Griffin"]
  spec.email         = ["ggriffin@carecloud.com"]

  spec.summary       = %q{pakket hub core components}
  spec.description   = %q{pakket hub core components}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "mysql2"
  spec.add_development_dependency "factory_girl", "~> 4.3"
  spec.add_development_dependency "database_cleaner", "~> 1.4"
  spec.add_development_dependency "awesome_print", "~> 1.6"
  spec.add_development_dependency "pry", "~> 0.9.12"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "benchmark-ips"
  spec.add_development_dependency "log4r"
end
