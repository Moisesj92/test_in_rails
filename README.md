
# Notas de la clase

Escribir un código funcional es solo la mitad del trabajo, poder escribir un test que pruebe mediante código el correcto funcionamiento de lo que escribiste es la forma de entregar un trabajo completo, para hacer esto se aplica un paradigma que se denomina TDD (Test Driven Development) que en resumen es una forma de trabajar que recomienda escribir primero la prueba y luego hacer el código funcional para que esta prueba pase, asi nos aseguramos de que lo que estamos entregando cumple con la lógica de negocio que definimos y con lo que queríamos en un principio, luego de hacer funcionar la prueba puedes refactorizar tu código para que cumpla los estándares.

Existen varios tipos de pruebas, y todos se utilizan con fines diferentes, las unitarias te ayudan a probar la lógica de tus modelos, cálculos y cosas especificas de la clase que definiste, las de integración te ayudan a probar todo el conjunto con el que se relaciona tu clase y es una prueba mas abstracta en donde pruebas el resultado de tu vista o de controlador y no la lógica especifica de tu clase.

## Pruebas Unitarias
rails viene con una suite de pruebas basada en minitest la cual permite probar las diferentes clases que definamos haciendo uso del comando 

` rails test `

la lógica que define estas pruebas esta alojada en el directorio /test que se encuentra en la raíz del proyecto y contiene una estructura parecida a la que se encuentra en la carpeta /app, al utilizar el comando "generate" este nos creara un archivo en esta carpeta test que nos permitirá probar la clase.

la idea es ir definiendo la prueba básica que nos permita corroborar la lógica de nuestra clase y luego a medida de que aumenten los métodos o la complejidad de la misma ir agregando mas y mas pruebas, la suit de minitest que viene con rails nos permite definir las pruebas con la palabra test, pero también se pueden definir los métodos anteponiendo def test y el nombre de la prueba:

``` [ruby]
require "test_helper"

class PokemonTest < ActiveSupport::TestCase
  test "name is required" do
    pokemon = Pokemon.new
    assert_not pokemon.valid?

    pokemon.name = 'charmander'
    assert pokemon.valid?
  end
end

```

por lo general en las pruebas vamos a querer apoyarnos de estructuras predefinidas que por lo general en el proyecto real guardarías en la base de datos como registros, en la suite de prueba de rails puedes usar los fixtures, que son archivos en lo que puedes definir esta información y hacer que se inserte en tu BD como un nuevo registro y poder trabajar con el, para poder usarlo en las pruebas usas el nombre de tu fixture : y el nombre del objeto que definiste dentro de ese fixture 


## Pruebas de Integración

los test de integración nos permiten probar flujos o comunicación entre sistemas, probamos como funcionan diferentes unidades en conjunto para responder lo que esperamos (Controlador, modelo, views).

algo importante a destacar es que las pruebas de los modelos heredan de **ActiveSupport::TestCase** y las pruebas de los controladores heredan de **ActionDispatch::IntegrationTest** esto significa que existen diferentes métodos de pruebas en las diferentes clases, en las pruebas de integración que se hacen en los controladores existe un método **post** muy util para probar request al que se le pueden enviar parámetros y probar que la respuesta sea correcta.

``` [ruby]
require "test_helper"

class PokemonsControllerTest < ActionDispatch::IntegrationTest
  test "search for a new pokemon" do
    params = {
      name: 'pikachu'
    }

    assert_difference "Pokemon.count" do
      post search_path, params: params
    end

    assert_equal "pikachu´s number is 25", flash[:notice]
    assert_redirected_to root_path

  end
end
```
tus archivos de pruebas deben empezar con el **require test_helper** en este archivo puedes indicar calses o metodos que quiras que esten disponible en toda tu suite o ambiente de pruebas, todos los archivos de pruebas deben llevar test en el nombre.

## Mocks y VCR
Los Mock objects y la herramienta VCR se utilizan para evitar hacer llamados excesivos a apis en las pruebas, representando o guardando una respuesta de algún api para poder reutilizarla cuantas veces sea necesario. 

los mocks vienen a ser cascarones vacios que simulan ser una respuesta o objeto retornados por el api y que podemos usar cada vez que se corran las pruebas sin necesidad de estar consultando al api real en cada iteracion, para usar este metodo de simulacion de request se necesita la biblioteca mocha que se debe agregar en el gemfile en la parte de ambiente test y luego de instalar se debe incluir en el archivo test_helper para poder ser usado en la suite o ambiente de pruebas:

``` [ruby]

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gen "mocha"
end

### Test Helper ###
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mocha/minitest"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
### Test Helper ###

```

al incluir mocha minitest en el rails helper se habilitan varios métodos que podemos utilizar para simular los comportamientos de request al api y nos permite hacer un mock object de la respuesta de la api, los inconvenientes de este método es que corremos el riesgo de crear una prueba que nunca falle debido al objeto que estamos creando:

``` [ruby]
  test "search for a new pokemon" do
    params = {
      name: 'pikachu'
    }

    assert_difference "Pokemon.count" do
      PokemonLocatorService.any_instance.expects(:call).returns(Pokemon.create(name: 'pikachu', number: '25'))
      post search_path, params: params
    end

    assert_equal "pikachu´s number is 25", flash[:notice]
    assert_redirected_to root_path
  end
```

## System tests
Los system test son pruebas que se realizan emulando el comportamiento del usuario en el navegador, la herramienta por defecto en rails
para realizar system test es kapibara y las pruebas heredan de ApplicationSystemTestCase, por defecto rails al correr las pruebas ignora este tipo
de pruebas pero puden correrse con:

`rails test:system`

### coverage
El coverage de las pruebas indica cuanto de tu codigo esta siendo realmente probado, existe una gema que te permite tener conocimiento de este porcentaje

[simple cov](https://github.com/simplecov-ruby/simplecov "Simple cov")

