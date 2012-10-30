class Wikipedia

  constructor:()->
    console.log 'wikipedia start'
    @rss = require "../../submodules/node-rss/node-rss"
    @mongoose = require 'mongoose'
    @trend_api = "http://www.google.co.jp/m/services/trends/get?hl=ja&gl=jp"
    @wikipedia_api = "http://wikipedia.simpleapi.net/api?"

  get:(fn)->
    wikipediaModel = @mongoose.model 'wikipedia'
    body = ""
    wikipediaModel.find {},{},{sort:{date:-1},limit:20}, (err, docs)=>
      body += "Wikipediaチャンネルです。!!!"
      _.each docs,(doc)=>
        body += doc.trend + "についてです。!!!"
        body += doc.title + "!!!"
        body += doc.content + "!!!"
      fn body

  reset:()->
    wikipediaModel = @mongoose.model 'wikipedia'
    wikipediaModel.find {}, (err, docs)=>
      _.each docs, (doc)->
        doc.remove()

  set:()->
    $.ajax
      url: @trend_api
      type: "GET"
      dataType: "html"
      success: (data)=>
        trends = $(data).find("item > query")
        _.each trends, (trend)=>
          key = $(trend).html()
          @setWikipediaContent key, 0
      error: (err)->
        console.log err
        return false

  setWikipediaContent:(key, retryCount)->
    $.ajax
      url:@wikipedia_api
      type: "POST"
      data:
        keyword: key
        output:  'xml'
      dataType: 'html'
      success:(data)=>
        title = $(data).find("title:first")
        content = $(data).find("body:first")
        if $(title).html() is null && retryCount <= 5
          retryCount += 1
          @setWikipediaContent key, retryCount
        else if $(title).html() is null && retryCount > 5
          return false
        else
          #正規表現で、<br/>などの削除
          title =  $(title).html()
          content = $(content).html()
          wikipediaModel = @mongoose.model 'wikipedia'
          wikipediaModel.find {title:title},(err, docs)=>
            if err
              throw err
            if docs.length == 0
              instance = new wikipediaModel()
              instance.title = title
              instance.content = content
              instance.trend = key
              instance.date = new Date()
              instance.save (err)->
                if err
                  throw err
                else
                  console.log 'success!'

      error:(err)->
        console.log err

module.exports = Wikipedia