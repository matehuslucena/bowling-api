![ruby](https://img.shields.io/badge/Ruby-2.3.0-green.svg)
![rails](https://img.shields.io/badge/Rails-5.0.0-green.svg)

**BOWLING API**

An API to manage a bowling game

To use just make a clone or fork and run

<code> $ bundle install </code>

After install dependencies, run

<code>$ rake db:create db:migrate</code>

To create the database

And to start the server and access the application, run

<code> $ rails server</code>

To start a new game make a POST request to <code>http://localhost:3000/games</code>

To make a new throw make a PUT request to <code>http://localhost:3000/games/game_id</code>

To check scores of a game make a GET request to <code>http://localhost:3000/games/:game_id?knocked_pins=:number_of_knocked_pins</code>

To execute the test, just run

<code>rspec</code>
