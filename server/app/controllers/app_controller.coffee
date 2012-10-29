XMLHttpRequest = require('xmlhttprequest').XMLHttpRequest
fs = require 'fs'
Url = require 'url'
http = require 'http'
weather = require("./weather")()
news = require("./news")()
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
      res.send news.get(req.params.area)

    tts: (req, res, next)->

      opts = Url.parse "http://translate.google.com/translate_tts?tl=ja&q=%E3%81%93%E3%82%93%E3%81%B0%E3%82%93%E3%82%8F"
      req = http.request
        host: opts.hostname
        port: opts.port
        path: opts.pathname + (opts.search || '')
        method: "GET"
      req.on 'response', (response)->
        response.on 'data', (chunk)->
          res.render 'translate'
            req:req
            t: chunk
      req.on 'error', (err)->
        #console.log err
      req.end()

    weather: (req,res,next)->
      console.log weather.get(req.params.area)
      res.send weather.get(req.params.area)

    websocket: (socket)->
      socket.on 'weather', (data)->
        socket.emit "weather"
          contents: weather.get(data.area)
  }
