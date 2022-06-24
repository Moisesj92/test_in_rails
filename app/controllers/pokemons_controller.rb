class PokemonsController < ApplicationController

  def index
  end

  def search
    pokemon =  PokemonLocatorService.new(params[:name]).call
    if pokemon
      flash[:notice] = "#{pokemon.name}´s number is #{pokemon.number}"
    else
      flash[:error] = "No pokemon found"
    end
    redirect_to root_path
  end

end
