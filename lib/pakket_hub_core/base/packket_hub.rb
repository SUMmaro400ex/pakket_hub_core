module PakketHub
  
  GREAT_CIRCLE = 3956.15898291568


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

  def self.to_bigdec(*args)
    rtn = args.map do |v|
      (v.nil? or v.is_a?(BigDecimal)) ? v : BigDecimal(v.to_f.to_s)
    end
    rtn.length < 2 ? rtn.first : rtn
  end

  def self.to_rad(*degrees)
    rtn = degrees.map do |v|
      v = to_bigdec(v)
      to_bigdec(v / 180.0 * Math::PI)
    end
    rtn.length < 2 ? rtn.first : rtn
  end

  def self.distance(lat1, lon1, lat2, lon2)
    lat1, lon1, lat2, lon2 = to_bigdec(lat1, lon1, lat2, lon2)

    dlon_rad, dlat_rad = to_rad( lon2 - lon1, lat2 - lat1 )
    lat1_rad, lon1_rad, lat2_rad, lon2_rad = to_rad(lat1, lon1, lat2,lon2)

    a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad/2))**2
    c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))

    GREAT_CIRCLE * c
  end
end