class SystemPermit < Permit::Base
  def initialize(ability, options = {})
    super
  end

  def permit?(user, options = {})    
    super
  end  
end
