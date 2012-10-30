class News
  api: "http://sankei.jp.msn.com/rss/news/flash.xml"

  constructor:()->
    console.log 'news constructor'
    @rss = require '../../submodules/node-rss/node-rss'
    @jsdom = require 'jsdom'
    @mongoose = require 'mongoose'

  get:(fn)->
    newsModel = @mongoose.model 'news'
    body = ''
    newsModel.find {}, {}, {sort:{date:-1},limit:20}, (err, docs)=>
      body += "ニュースチャンネルです。本日の最新ニュースをお届けします。!!!"
      _.each docs, (doc)->
        body += doc.title + "!!!"
        body += doc.content + "!!!"
      fn body

  reset:()->
    newsModel = @mongoose.model 'news'
    newsModel.find {}, (err, docs)->
      if err
        throw err
      _.each docs,(doc)->
        doc.remove()

  set:()->
    response = @rss.parseURL @api, (articles)=>
      console.log articles
      _.each articles, (article)=>
        $.ajax
          url:article.link
          type: "GET"
          success:(data)=>
            title = $(data).find("#NewsTitle").html()
            titleRegExp = new RegExp("<div>.+</div>")
            title = title.replace(titleRegExp,"")
            content  = $(data).find(".NewsTextFull p").html()
            date  = $(data).find(".DateandPage .Timestamp").html()
            newsModel = @mongoose.model 'news'
            newsModel.find title: title, (err, docs)=>
              if err
                throw err
              if docs.length ==0
                instance = new newsModel()
                instance.title = title
                instance.content = content
                instance.date = new Date date
                instance.save (err)->
                  if err
                    throw err
                  else
                    console.log 'success'
          error:(err)->
            console.log err

module.exports = News