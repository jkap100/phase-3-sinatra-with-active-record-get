class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/' do
    { message: 'Hello world' }.to_json
  end

  get '/games' do
    # get all games from the database
    games = Game.all.order(:title).limit(5)

    #return a JSON respons with an array of all the game data
    games.to_json
  end

  get '/games/:id' do
    #look up the game in the database using its id
    game = Game.find(params[:id])

    #send a JSON-formmatted response of the game data
    # game.to_json(include: { reviews: { include: :user } })
    game.to_json(
      only: %i[id title genre price],
      include: {
        reviews: {
          only: %i[comment score],
          include: {
            user: {
              only: [:name],
            },
          },
        },
      },
    )
  end
end
