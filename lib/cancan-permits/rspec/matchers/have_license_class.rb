module RSpec::RubyContentMatchers 
  module License 
    def have_license_class name, superclass = nil
      superclass ? have_subclass(name, :superclass => superclass) : have_class(name)
    end    

    def have_license_classes *names
      have_classes names
    end    
  end
end