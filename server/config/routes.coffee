module.exports = (app, io) ->

  # Controller
  controllers   = app.settings.controllers
  AppController = controllers.AppController app
  ContentsGetter = controllers.ContentsGetter app

  #Websocket
  io.sockets.on 'connection', AppController.websocket
  #news = io.of("/news").on "connection", AppController.websocket.news


  # Routing
  app.get "/weather/:area", AppController.weather
  ###
  app.get '/', AppController.index
  app.get '/tts', AppController.tts
  app.get '/news', AppController.news
###
