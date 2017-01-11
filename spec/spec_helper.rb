require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |c|
  c.platform = 'Ubuntu'
  c.version = '14.04'
end
