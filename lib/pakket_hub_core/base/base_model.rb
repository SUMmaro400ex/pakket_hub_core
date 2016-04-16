require 'packket_hub_core/base/core_functionality'

class PakketHub::BaseModel < ActiveRecord::Base
  include PakketHub::CoreFunctionality
  self.abstract_class = true
  self.store_full_sti_class = false
end