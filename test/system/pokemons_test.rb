require "application_system_test_case"

class PokemonsTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit root_url

    assert_selector "h1", text: "Pokemon Test"
  end

  test "search for a pokemon" do
    visit root_url

    VCR.use_cassette("search_pikachu") do
      fill_in "name", with: "pikachu"
      click_on "Search"
    end
    assert_selector "div", text: "pikachu's number is 25"
  end
end