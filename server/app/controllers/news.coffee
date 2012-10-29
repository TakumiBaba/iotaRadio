#fs = require 'fs'
#feedparser = require 'feedparser'

module.exports = ()->
  return{
    get: (area)->
      $.ajax
        url: 'http://sankei.jp.msn.com/rss/news/flash.xml'
        type: 'GET'
        dataType: 'text'
        success: (data) ->
          feedparser.parseString(data).on('article', console.log);
        error: (req, status, err) ->
          console.log status
      return 
      #weatherDir = "./public/weather_channel/"
      # aCodeList = fs.readdirSync weatherDir
      body = "hello"
      # body += fs.readFileSync weatherDir+aCode+"/detail.txt"
      return body

    reload: ()->
      _.each getPrefecturesData(), (d)->
        p = d.prefecture
        _.each d.cities, (value, key)->
          set(p, key, value.code)

    set: (pName, cName, aCode)->
      
      #天気全般
      # $.ajax
      #   url: "http://w002.tenkiapi.jp/"+userID+"/daily/?p1="+areacode+"&p2=01&type=json"
      #   type: 'GET'
      #   dataType: "json"
      #   success: (data)->
      #     d = data.daily
      #     weather = d.wDescription
      #     console.log d
      #     temp.max = d.maxTemp
      #     temp.min = d.minTemp
      #     countCheck()
      #   error: ()->
      #     console.log 'error'
  }