require "test_helper"

class PokemonLocatorServiceTest < ActiveSupport::TestCase

  test "when pokemo exist in databse" do
    assert_no_difference "Pokemon.count", "No new pokemons are created" do
      pokemon = PokemonLocatorService.new('charmander').call
      assert_equal "4", pokemon.number
    end
  end

  test "when pokemon dosent exit in database" do
    assert_difference "Pokemon.count" do
      pokemon = PokemonLocatorService.new('pikachu').call
      assert_equal "25", pokemon.number
    end
  end

  test "when pokemon is invalid" do
    assert_no_difference "Pokemon.count", "No new pokemos are created" do
      pokemon = PokemonLocatorService.new('Pika').call
      assert_nil pokemon
    end
  end

  test "when pokemon whit multiple names is invalid" do
    assert_no_difference "Pokemon.count", "No new pokemos are created" do
      pokemon = PokemonLocatorService.new('Pika Pika').call
      assert_nil pokemon
    end
  end

end