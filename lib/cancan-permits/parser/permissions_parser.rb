module Permits
  module Parser
    class Permissions
      def initialize
      end

      def parse(key, obj, &blk)
        license = Permits::Configuration::Permissions.new key
        case obj
        when Hash
          parse_permission(obj, license, &blk)
        else
          raise "Each key must have a YAML hash that defines its permission configuration"
        end
        yield license if blk
      end      

      protected

      def parse_permission(obj, license, &blk)
        # Forget keys because I don't know what to do with them
        obj.each do |key, value|   
          raise ArgumentError, "A CanCan license can only have the keys can: and cannot:" if ![:can, :cannot].include?(key.to_sym)
          license.send :"#{key}=", value
        end
      end
    end
  end
end
