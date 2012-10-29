module.exports = (app, io) ->

  # Controller
  controllers   = app.settings.controllers
  AppController = controllers.AppController app
  ContentsGetter = controllers.ContentsGetter app

  #Websocket
  io.sockets.on 'connection', AppController.websocket
  #news = io.of("/news").on "connection", AppController.websocket.news


  # Routing
  app.get "/weather/get/get", AppController.weather_test
  app.get "/weather/:prefecture/:area", AppController.weather
  app.get "/chiebukuro", AppController.chiebukuro
  app.get "/chiebukuro_get", AppController.chiebukuroGet
  app.get "/chiebukuro_reset", AppController.chiebukuroReset