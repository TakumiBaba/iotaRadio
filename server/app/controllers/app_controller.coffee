XMLHttpRequest = require('xmlhttprequest').XMLHttpRequest
fs = require 'fs'
Url = require 'url'
http = require 'http'
weather = require("./weather")()
Chiebukuro = require "./chiebukuro"
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

    news: (req, res, next)->
      $.ajax
        type: "GET"
        dataType: 'xml'
        url: "http://news.yahooapis.jp/NewsWebService/V1/Topics?appid=QgolUhOxg66v9Cjr795kmpFfbGT9il5vtJev3DeQ2U_c6cylTHE1dOiYeoQj1Bg-"
        success: (data)->
          console.log 'success'
          res.json data
        error: (e)->
          results = e.responseText
          results = $(results).find 'result'
          p = ""
          for result in results
            if result._childNodes._nodeName is 'title'
              p += result._childNodes._nodeName + "\n"

          res.send p

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

    chiebukuro:(req, res, next)->
      c = new Chiebukuro()
      c.set()
      res.send 'hoge'
    chiebukuroGet:(req, res, next)->
      c = new Chiebukuro()
      hoge = c.get()
      res.json hoge

    weather: (req,res,next)->
      body = weather.get req.params.prefecture, req.params.area, (body)->
        res.json body



    weather_test:(req, res, next)->
      weather.reload()
      res.send 'hoge'

    websocket: (socket)->
      socket.on 'weather', (data)->
        weather.get data.prefecture, data.area, (d)->
          socket.emit 'weather'
            contents: d

  }
