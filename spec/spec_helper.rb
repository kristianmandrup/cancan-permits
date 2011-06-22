require 'rspec/core'
require 'cancan/matchers'
require 'cancan-permits' 
require 'cancan-permits/rspec'
require 'simple_roles'

require 'cutter'
Cutter::Inspection.quiet!


SPEC_DIR = File.dirname(__FILE__)

require_all File.dirname(__FILE__) + '/fixtures/permits'
