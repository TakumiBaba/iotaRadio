XMLHttpRequest = require('xmlhttprequest').XMLHttpRequest
fs = require 'fs'
Url = require 'url'
http = require 'http'
weather = require("./weather")()
News = require "./news"
Chiebukuro = require "./chiebukuro"
Wikipedia = require "./wikipedia"
exports.AppController = (app) ->

  {App} = app.settings.models

  return {
    index: (req, res, next) ->
      res.render 'index'
        req: req
    test: (req, res, next)->
      res.render 'translate'
        req: req
        t: req.params.test

    news: (req,res,next)->
      n = new News()
      n.set()
      res.send 'news'
    news_get: (req, res, next)->
      n = new News()
      n.get (d)->
        res.send d
    news_reset: (req, res, next)->
      n = new News()
      n.reset()
      res.send 'reset'
    chiebukuro:(req, res, next)->
      c = new Chiebukuro()
      c.autoreload()
      res.send 'hoge'
    chiebukuroGet:(req, res, next)->
      c = new Chiebukuro()
      hoge = c.get (d)->
        res.send d
    chiebukuroReset:(req, res, next)->
      c = new Chiebukuro()
      c.reset()
      res.send 'reset'
    chiebukuroPost:(req, res, next)->
      c = new Chiebukuro()
      c.post "ばばたくみ", "コンピュータテクノロジー", "こんばんわ！"
      res.send 'post'

    weather: (req,res,next)->
      body = weather.get req.params.prefecture, req.params.area, (body)->
        res.json body
    weather_test:(req, res, next)->
      weather.reload()
      res.send 'hoge'

    wikipedia: (req, res, next)->
      w = new Wikipedia()
      w.set()
      res.send 'set'
    wikipediaGet: (req, res, next)=>
      w = new Wikipedia()
      w.get (d)->
        res.send d
    wikipediaReset: (req, res, next)=>
      w = new Wikipedia()
      w.reset()
      res.send 'reset'

    websocket: (socket)->
      socket.on 'weather', (data)->
        weather.get data.prefecture, data.area, (d)->
          socket.emit 'weather'
            contents: d
      socket.on 'chiebukuro', (data)->
        c = new Chiebukuro()
        c.get (d)->
          socket.emit 'chiebukuro'
            contents: "お母さんはそんなに嵐が好きではありませんが物心ついたころには一緒にDの嵐を見てました。それからだんだん好きになって、やっと今年にFCに入会しました！(親が中１になってからというので) だから、ファン歴は7、8年ぐらいでしょうね。!!!続いてのテーマは、エンターテインメントと趣味です。"
      socket.on "news", (data)->
        n = new News()
        n.get (d)->
          socket.emit "news"
            contents: d
      socket.on 'wikipedia', (data)->
        w = new Wikipedia()
        w.get (d)->
          socket.emit 'wikipedia'
            contents: d

  }
