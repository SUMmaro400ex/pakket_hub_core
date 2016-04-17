$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pakket_hub_core'
require 'pakket_hub_core/testing_support'
require 'factory_girl'
require 'rspec'
require 'database_cleaner'
require 'awesome_print'
require 'pry'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

ActiveRecord::Base.configurations = YAML.load_file("spec/config/database.yml")
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])


Dir["./spec/support/**/*.rb"].sort.each { |f| require f}
Dir["./spec/factories/*.rb"].sort.each { |f| require f}

do_logging = false

if do_logging
  require 'log4r'
  Log4r::StderrOutputter.new('console')
  log = Log4r::Logger.new('logger')
  log.add('console')
  log.level = 0
  ActiveRecord::Base.logger = log
end