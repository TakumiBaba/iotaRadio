rss      = require '../submodules/node-rss/node-rss'

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
  app.get '/news/set', AppController.news
  app.get '/news/get', AppController.news_get
  app.get "/news/reset", AppController.news_reset
  ###
  app.get "/news", (req, res) ->
    response = rss.parseURL 'http://sankei.jp.msn.com/rss/news/flash.xml', (articles)->
      console.log articles
      sys.puts(articles.length);
      result_text = ""
      for article, i in articles
        description = article.description
        # # 記事ジャンル削除
        # description = description.replace /【.*】/, ""
        # # 年齢削除
        # description = description.replace /（[０-９][０-９]）/, ""
        result_text += "#{article.title}\n#{description}"
      res.send result_text
      ###
  app.get "/weather/get/get", AppController.weather_test
  app.get "/weather/:prefecture/:area", AppController.weather
  app.get "/chiebukuro", AppController.chiebukuro
  app.get "/chiebukuro_get", AppController.chiebukuroGet
  app.get "/chiebukuro_reset", AppController.chiebukuroReset
  app.get "/chiebukuro_post", AppController.chiebukuroPost

  app.get "/wikipedia/set", AppController.wikipedia
  app.get "/wikipedia/get", AppController.wikipediaGet
  app.get "/wikipedia/reset", AppController.wikipediaReset