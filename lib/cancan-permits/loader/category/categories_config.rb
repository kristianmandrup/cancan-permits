class CategoriesConfig
  attr_accessor :name, :categories
  
  def initialize name
    @name = name
    @categories = {}
  end  

  # test if a particular category has a certain subject
  def category_has_subject? category, subject, &block
    found = categories[category].include? subject
    yield if found && block
    found
  end  

  # test if a any of the categories contain the subject
  def has_subject? subject, &block
    found = categories.any? {|cat| cat.include? subject }
    yield if found && block
    found
  end  

  # find the category of a subject if such a category exists
  def category_of_subject subject, &block
    found_cat = categories.select {|cat| cat.include? subject }
    yield found_cat if cat && block
    found_cat
  end  
end
