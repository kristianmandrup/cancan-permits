module Permit               
  module Util
    def permit_name clazz
      clazz.demodulize.gsub(/Permit$/, '').underscore.to_sym      
    end
  end
end
