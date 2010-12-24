require 'rspec/core'
require 'cancan/matchers'
require 'cancan-permits' 
require 'cancan-permits/rspec'

SPEC_DIR = File.dirname(__FILE__)

require_all File.dirname(__FILE__) + '/fixtures/permits'
