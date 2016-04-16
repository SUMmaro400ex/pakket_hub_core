require 'ostruct'
require 'active_record'
require 'active_support/inflector'
require 'active_support/core_ext/array'
require 'active_support/cache/memory_store'
require 'pakket_hub_core/version'

module PakketHub
  def self.gem_root
    File.dirname(File.absolute_path(__FILE__))
  end

  def self.require_dir(*dir_names)
    dir_names.flatten.each do |dir_name|
      Dir[gem_root + "/pakket_hub_core/#{dir_name}/**/*.rb"].each { |f| require f}
    end
  end

end

PakketHub.require_dir("base","behaviors","models","services")

#Dir[PakketHubCore.gem_root + "/pakket_hub_core/testing_support/**/*.rb"].each { |f| require f}
