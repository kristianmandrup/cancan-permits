class CategoriesParser
  def initialize
  end

  def parse key, obj, &blk
    category = ::CategoriesConfig.new key
    case obj
    when Hash
      parse_category(obj, category, &blk)
    else
      raise "Each key must have a YAML hash that defines which models make up the category (related kinds of items)"
    end
    yield category if blk
  end      

  protected

  def parse_category obj, category, &blk
    # Forget keys because I don't know what to do with them
    obj.each do |key, value|
      category.categories[key] = value
    end
  end
end