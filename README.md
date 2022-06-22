
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

## Mocks y VCR

## System tests