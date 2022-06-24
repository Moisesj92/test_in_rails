class PokemonLocatorService

  def initialize(name)
    @name = name
  end

  def call
    pokemon = Pokemon.find_by(name: name) || remote_pokemon_search
  rescue JSON::ParserError 
  end

  private

  attr_reader :name

  def remote_pokemon_search
    response = PokeApi.get(pokemon: ERB::Util::url_encode(name))
    Pokemon.create(name: response.name, number: response.id)
  end

end