class PushFunds
  attr_accessor :exchange, :post_response, :transaction_identifier

  def initialize
    # (exchange)
    # @exchange = exchange
  end
# Sample post body payload

  def post_pay_load
  '''{
  "acquirerCountryCode": "840",
  "acquiringBin": "408999",
  "amount": "124.05",
  "businessApplicationId": "AA",
  "cardAcceptor": {
    "address": {
      "country": "USA",
      "county": "San Mateo",
      "state": "CA",
      "zipCode": "94404"
    },
    "idCode": "CA-IDCode-77765",
    "name": "Visa Inc. USA-Foster City",
    "terminalId": "TID-9999"
  },
  "localTransactionDateTime": "2016-04-17T01:15:33",
  "merchantCategoryCode": "6012",
  "pointOfServiceData": {
    "motoECIIndicator": "0",
    "panEntryMode": "90",
    "posConditionCode": "00"
  },
  "recipientName": "rohan",
  "recipientPrimaryAccountNumber": "4957030420210496",
  "retrievalReferenceNumber": "412770451018",
  "senderAccountNumber": "4653459515756154",
  "senderAddress": "901 Metro Center Blvd",
  "senderCity": "Foster City",
  "senderCountryCode": "124",
  "senderName": "Mohammed Qasim",
  "senderReference": "",
  "senderStateCode": "CA",
  "sourceOfFundsCode": "05",
  "systemsTraceAuditNumber": "451018",
  "transactionCurrencyCode": "USD",
  "transactionIdentifier": "381228649430015"
  }'''
  end

  def post_request
    base_uri = 'visadirect/'
    resource_path = 'fundstransfer/v1/pushfundstransactions/'
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
          :ssl_client_key => OpenSSL::PKey::RSA.new(PakketHub.visa_client_key),
          # PakketHub.visa_client_key
          :ssl_client_cert =>  OpenSSL::X509::Certificate.new(PakketHub.visa_client_cert)
          # PakketHub.visa_client_cert
      )
    rescue RestClient::ExceptionWithResponse => e
      response = e.response
    end
      @post_response = response
  end

  def feth_post_response
    JSON.pretty_generate(JSON.parse(post_request))
  end

  def push_funds
    feth_post_response
    # update_exchange if transaction_identifier
  end

  def transaction_identifier
    byebug
    @transaction_identifier ||= JSON.parse(@post_response)["transactionIdentifier"]
  end

  def update_exchange
    exchange.transaction_identifier = transaction_identifier
  end

end
