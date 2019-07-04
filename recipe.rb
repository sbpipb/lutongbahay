require 'byebug'
require 'awesome_print'

class RecipeIngredient
end

class Recipe; end;

Recipe.instance_eval do
  RECIPES = {}

  def recipe(name, &blk)
    @recipe = name
    RECIPES[name] = { ingredients: [], steps: [] }
    if block_given?
      blk.call
    end
  end

  def describe(&blk)
    instance_eval(&blk)
  end

  def ingredient(item)
    RECIPES[@recipe][:ingredients] << item 
  end

  def step(instruction)
    RECIPES[@recipe][:steps] << instruction
  end

  def for(dish)
    recipe = RECIPES[dish]
    ingr = recipe[:ingredients]
    steps = recipe[:steps]

    <<~HEREDOC
      #{dish}
      
      Ingredients:
      #{to_string(ingr)}
      Instructions:
      #{to_string(steps)}
    HEREDOC
  end

  def to_string(array)
    results = ''
    array.each do |a|
      results += a + "\n"
    end
    results
  end
end

Recipe.describe do
  recipe "Hard Boiled Egg" do
    ingredient "1 Egg"
    ingredient "1L Water"
    step "Place water in container"
    step "Place egg in water container"
    step "Boil water"
  end

  recipe "Bacon Surprise" do
    ingredient "3 strips of bacon"
    ingredient "1 ampalaya"
    ingredient "1 egg"
    ingredient "1 chili pepper"
    step "Mince egg"
    step "Cube ampalaya"
    step "Strip bacon"
    step "Sprinkle pepper"
    step "Call 911"
  end
end

puts Recipe.for("Hard Boiled Egg")
