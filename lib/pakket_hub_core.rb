require "pakket_hub_core/version"



module PakketHub
  def self.gem_root
    File.dirname(File.absolute_path(__FILE__))
  end
end

Dir[PakketHub.gem_root + "/pakket_hub_core/base/**/*.rb"].each { |f| require f}
Dir[PakketHub.gem_root + "/pakket_hub_core/behaviors/**/*.rb"].each { |f| require f}
Dir[PakketHub.gem_root + "/pakket_hub_core/models/**/*.rb"].each { |f| require f}
#Dir[PakketHubCore.gem_root + "/pakket_hub_core/services/**/*.rb"].each { |f| require f}
#Dir[PakketHubCore.gem_root + "/pakket_hub_core/testing_support/**/*.rb"].each { |f| require f}
