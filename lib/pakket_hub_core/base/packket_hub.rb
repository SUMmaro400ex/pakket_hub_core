module PakketHub
  

  def self.visa_client_key
    @client_key
  end

  def self.visa_client_cert
    @client_cert
  end

  def self.visa_client_key=(val)
    @client_key = val
  end

  def self.visa_client_cert=(val)
    @client_cert = val
  end
end