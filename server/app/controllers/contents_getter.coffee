http = require 'http'
Url  = require 'url'
parser = require "libxml-to-js"
jsdom = require 'jsdom'
fs = require 'fs'
pref = (require '../../config/weather')()
CronJob = require('cron').CronJob

exports.ContentsGetter = (app)->

  #weather_cront_time = "00 00 1,6,12,18 * * *"
  weather_cront_time = "00 11 * * * *"
  weather_job = new CronJob
    cronTime: weather_cront_time
    onTick: ()->
      console.log "get weather data"
      _.each pref, (d)->
        p = d.prefecture
        _.each d.cities, (value, key)->
          weatherChannel(p, key, value.code)
    onComplete: ()->
      console.log "complete getting weather data"
    start: false
    timeZone: "Japan/Tokyo"
  weather_job.start()

  yahoo_appid = "QgolUhOxg66v9Cjr795kmpFfbGT9il5vtJev3DeQ2U_c6cylTHE1dOiYeoQj1Bg-"
  topic_api = "http://news.yahooapis.jp/NewsWebService/V1/Topics"

  weatherChannel = (pName, cName, aCode)->
    apiCount = 11
    serverID = "w002"
    userID   = "e2546d6779cc220ce1f4924d8e5d553203582559"
    domain = "tenkiapi.jp"
    areacode = aCode
    weather = ""
    #最高気温、最低気温がうまく取れていないので修正しよう
    temp = {max:0,min:0,effective:0}
    pollen = {}
    comfort = {num:0,rank:0}
    wash = {num:0,rank:0}
    violet ={num:0,rank:0}
    umbrella = cough =　skin = hotpot = 0
    beer = ice = starry = quilt = cloth_layer = 0

    countCheck = ()->
      apiCount -= 1
      detail = "#{pName}、#{cName}の天気は、#{weather},最低気温は、#{temp.min}℃最高気温は、#{temp.max}℃です。体感温度は、#{temp.effective}です。続いて各種指数についてお知らせします。紫外線指数は #{violet.num} と#{violet.rank}でしょう。傘指数は、#{umbrella}です。洗濯指数は、#{wash.num}で#{wash.rank}でしょう。風邪ひき指数は、#{cough}です。素肌乾燥指数は、#{skin}です。鍋物指数は、#{hotpot}です。星空指数は、#{starry}です。掛け布団指数は、#{quilt}です。重ね着指数は、#{cloth_layer}です。"
      simple = "#{pName}、#{cName}の天気は、#{weather},最低気温は、#{temp.min}℃最高気温は、#{temp.max}℃です。"
      if apiCount is 0
        fileDir = "./public/weather_channel/"+areacode+"/"
        weatherDir = fs.readdir fileDir, (err, files)->
          if err
            fs.mkdirSync fileDir
          fs.writeFile fileDir+"detail.txt", detail, (err)->
            if err
              console.log 'detail'
              throw err
          fs.writeFile fileDir+"simple.txt", simple, (err)->
            if err
              console.log 'simple'
              throw err
          console.log simple

    ###
    花粉指数、熱中症指数、不快指数、ビール指数、アイスクリーム指数に関しては
    これからの季節的には情報取得できないのでとりあえず取得しない
    ###

    #天気全般
    $.ajax
      url: "http://w002.tenkiapi.jp/"+userID+"/daily/?p1="+areacode+"&p2=01&type=json"
      type: 'GET'
      dataType: "json"
      success: (data)->
        d = data.daily
        weather = d.wDescription
        console.log d
        temp.max = d.maxTemp
        temp.min = d.minTemp
        countCheck()
      error: ()->
        console.log 'error'
    #体感温度　ちょっと厳しいかも
    $.ajax
      url: "http://w002.tenkiapi.jp/"+userID+"/cold/?p1="+areacode+"&p2=01&type=json"
      type: 'GET'
      dataType: "json"
      success: (data)->
        temp.effective = data.cold.coldnessIndex[0].ranking
        countCheck()
      error: ()->
        console.log 'error'
    #紫外線情報
    $.ajax
      url: "http://w002.tenkiapi.jp/"+userID+"/violet/?p1="+areacode+"&p2=01&type=json"
      type: 'GET'
      dataType: "json"
      success: (data)->
        violet.num  = data.violet.uvIndex[0].value
        violet.rank = data.violet.uvIndex[0].ranking
        countCheck()
      error: ()->
        console.log 'error'
    #傘指数
    $.ajax
      url: "http://w002.tenkiapi.jp/"+userID+"/umbrella/?p1="+areacode+"&p2=01&type=json"
      type: 'GET'
      dataType: "json"
      success: (data)->
        umbrella = data.umbrella.umbrellaIndex[0].ranking
        countCheck()
      error: ()->
        console.log 'error'
    #洗濯指数
    $.ajax
      url: "http://w002.tenkiapi.jp/"+userID+"/wash/?p1="+areacode+"&p2=01&type=json"
      type: 'GET'
      dataType: "json"
      success: (data)->
        wash.num = data.wash.clothDriedIndex[0].value
        wash.ranking = data.wash.clothDriedIndex[0].ranking
        countCheck()
      error: ()->
        console.log 'error'
    #風邪ひき指数
    $.ajax
      url: "http://w002.tenkiapi.jp/"+userID+"/cough/?p1="+areacode+"&p2=01&type=json"
      type: 'GET'
      dataType: "json"
      success: (data)->
        cough = data.cough.coughIndex[0].value
        countCheck()
      error: ()->
        console.log 'error'
    #素肌乾燥指数
    $.ajax
      url: "http://w002.tenkiapi.jp/"+userID+"/skin/?p1="+areacode+"&p2=01&type=json"
      type: 'GET'
      dataType: "json"
      success: (data)->
        skin = data.skin.skinDriedIndex[0].value
        countCheck()
      error: ()->
        console.log 'error'
    #鍋物指数
    $.ajax
      url: "http://w002.tenkiapi.jp/"+userID+"/hotpot/?p1="+areacode+"&p2=01&type=json"
      type: 'GET'
      dataType: "json"
      success: (data)->
        hotpot = data.hotpot.hotPotIndex[0].value
        countCheck()
      error: ()->
        console.log 'error'
    #星空指数
    $.ajax
      url: "http://w002.tenkiapi.jp/"+userID+"/starry/?p1="+areacode+"&p2=01&type=json"
      type: 'GET'
      dataType: "json"
      success: (data)->
        starry = data.starry.starryIndex[0].value
        countCheck()
      error: ()->
        console.log 'error'
    #掛け布団指数
    $.ajax
      url: "http://w002.tenkiapi.jp/"+userID+"/quilt/?p1="+areacode+"&p2=01&type=json"
      type: 'GET'
      dataType: "json"
      success: (data)->
        quilt = data.quilt.quiltIndex[0].value
        countCheck()
      error: ()->
        console.log 'error'
    #重ね着指数
    $.ajax
      url: "http://w002.tenkiapi.jp/"+userID+"/clothLayer/?p1="+areacode+"&p2=01&type=json"
      type: 'GET'
      dataType: "json"
      success: (data)->
        cloth_layer = data.clothLayer.clothLayeringIndex[0].value
        countCheck()
      error: ()->
        console.log 'error'
