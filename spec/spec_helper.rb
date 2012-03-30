require 'fakeweb'
require 'klout'

FakeWeb.allow_net_connect = false

RSpec.configure do |config|
  config.before(:each) do
    FakeWeb.clean_registry
    @api_key = 'valid-api-key'
    @identity = File.read(File.expand_path('spec/klout/fixtures/identity.json'))
  end
end