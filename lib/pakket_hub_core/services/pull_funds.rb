class PullFunds
  attr_accessor :exchange, :post_response, :transaction_identifier

  def initialize(exchange)
    @exchange = exchange
  end
# Sample post body payload

  def post_pay_load
  '''{
    "businessApplicationId": "AA",
    "merchantCategoryCode": 6012,
    "pointOfServiceCapability": {
      "posTerminalType": "4",
      "posTerminalEntryCapability": "2"
    },
    "feeProgramIndicator": "123",
    "systemsTraceAuditNumber": 300259,
    "retrievalReferenceNumber": "407509300259",
    "foreignExchangeFeeTransaction": "10.00",
    "cardAcceptor": {
      "name": "Acceptor 1",
      "terminalId": "365539",
      "idCode": "VMT200911026070",
      "address": {
        "state": "CA",
        "county": "081",
        "country": "USA",
        "zipCode": "94404"
      }
    },
    "magneticStripeData": {
      "track1Data": "1010101010101010101010101010"
    },
    "senderPrimaryAccountNumber": "'''+"#{exchange.user.credit_card.number}"'''",
    "senderCurrencyCode": "USD",
    "surcharge": "1.00",
    "localTransactionDateTime": "2016-04-16T10:32:52",
    "senderCardExpiryDate": "2013-03",
    "pinData": {
      "pinDataBlock": "1cd948f2b961b682",
      "securityRelatedControlInfo": {
        "pinBlockFormatCode": 1,
        "zoneKeyIndex": 1
      }
    },
    "cavv": "0000010926000071934977253000000000000000",
    "pointOfServiceData": {
      "panEntryMode": "90",
      "posConditionCode": "0",
      "motoECIIndicator": "0"
    },
    "acquiringBin": 409999,
    "acquirerCountryCode": "101",
    "amount": '''+"#{exchange.amount}"'''
  }'''
  end

  def post_request
    base_uri = 'visadirect/'
    resource_path = 'fundstransfer/v1/pullfundstransactions/'
    url = 'https://sandbox.api.visa.com/' + base_uri + resource_path
    user_id = 'D8NR62RVCE743SB9S1QU21KCFFKyrQjV-YMlwrsHcmpCWPzr8'
    password = 'e9WPHxoAIKHU8yA8d'
    key_path = File.join(Rails.root, 'app', 'assets', 'key_Pakket Hub.pem')
    cert_path = File.join(Rails.root, 'app', 'assets', 'cert.pem')
    headers = {'content-type'=> 'application/json', 'accept'=> 'application/json'}
    begin
      response = RestClient::Request.execute(
          :method => :post,
          :url => url,
          :headers => headers,
          :payload => post_pay_load,
          :user => user_id, :password => password,
          :ssl_client_key => OpenSSL::PKey::RSA.new(File.read(key_path)),
          :ssl_client_cert =>  OpenSSL::X509::Certificate.new(File.read(cert_path))
      )
    rescue RestClient::ExceptionWithResponse => e
      response = e.response
    end
      @post_response = response
  end

  def feth_post_response
    JSON.pretty_generate(JSON.parse(post_request))
  end

  def pull_funds
    feth_post_response
    update_exchange if transaction_identifier
  end

  def transaction_identifier
    @transaction_identifier ||= JSON.parse(@post_response)["transactionIdentifier"]
  end

  def update_exchange
    exchange.transaction_identifier = transaction_identifier
  end

end
