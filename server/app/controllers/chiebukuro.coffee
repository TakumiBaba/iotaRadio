class Chiebukuro
  category_list:
    2078297513:"エンターテインメントと趣味"
    2078297937:"暮らしと生活ガイド"
    2078297382:"インターネット、PCと家電"
    2078297854:"健康、美容とファッション"
    2078297790:"ビジネス、経済とお金"
    2079526977:"生き方と恋愛、人間関係の悩み"
    2078297878:"子育てと学校"
    2078297897:"職業とキャリア"
    2078297811:"マナー、冠婚葬祭"
    2078297784:"ニュース、政治、国際情勢"
    2078297812:"教養と学問、サイエンス"
    2078297753:"スポーツ、アウトドア、車"
    2078297918:"地域、旅行、お出かけ"
    2078297616:"コンピュータテクノロジー"

  constructor:()->
    console.log 'construct'
    @mongoose = require 'mongoose'
    @APP_ID = "QgolUhOxg66v9Cjr795kmpFfbGT9il5vtJev3DeQ2U_c6cylTHE1dOiYeoQj1Bg-"
    @address = "http://chiebukuro.yahooapis.jp/Chiebukuro/V1/getNewQuestionList"
    @params = "&condition=solved&sort=-anscount&output=json"

  autoreload:()->
    _.each @category_list, (categoryname, categoryid)=>
      $.ajax
        url: @address+"?appid="+@APP_ID+@params+"&category_id="+categoryid
        type:"GET"
        success:(data)=>
          parentCategoryId = categoryid
          results = data.ResultSet.Result
          chiebukuroModel = @mongoose.model 'chiebukuro'
          _.each results, (result)=>
            chiebukuroModel.find questionId: result.QuestionId, (err, docs)=>
              if err
                throw err
              if docs.length == 0
                instance = new chiebukuroModel()
                instance.questionId = result.QuestionId
                instance.content = result.Content
                instance.category = result.Category
                instance.parentCategoryId = parentCategoryId
                instance.categoryId = result.ategoryId
                instance.bestAnswer = result.BestAnswer
                instance.save (err)->
                  if err
                    throw err
                  else
                    console.log 'success'
        error:(err)->
          console.log err
  reset:->
    chiebukuroModel = @mongoose.model 'chiebukuro'
    chiebukuroModel.find {}, (err, docs)->
      if !err
        _.each docs, (doc)->
          doc.remove()

  post:(name, category, message)->
    _.each @category_list, (c)=>
      if category is c
        console.log name
        console.log message

  get:(fn)->
    chiebukuroModel = @mongoose.model 'chiebukuro'
    body = "相談チャンネル〜。みなさんから頂いた質問や相談を、みんなで解決して行こうというコーナーです。質問は随時受け付けてますので皆さんからのお便りお待ちしております。"
    state = 0
    chiebukuroModel.find {}, (err, docs)=>
      _.each docs, (doc)=>
        _.each @category_list, (categoryname, categoryid)=>
          if doc.parentCategoryId is categoryid
            if state is 0
              state += 1
              body += "まず、最初のテーマは、#{categoryname}です。!!!"
            else
              body += "続いてのテーマは、#{categoryname}です。!!!"
            body += "こおりやまはやとさんの投稿です。!!!"
            body += doc.content+"!!!"
            body += "これに答えてくれたのは、あきやまひろきさんです!!!"
            body += doc.bestAnswer+"!!!"
      fn body
      ###
    _.each @category_list, (categoryname, categoryid)=>
      chiebukuroModel.find {parentCategoryId: categoryid}, (err, docs)=>
        _.each docs, (doc)=>
          console.log doc.content
          if state is 0
            state += 1
            body += "まず、最初のテーマは、#{categoryname}です。"
          else
            body += "続いてのテーマは、#{categoryname}です。"
          body += "こおりやまはやとさんの投稿です。"
          body += doc.content
          body += "これに答えてくれたのは、あきやまひろきさんです"
          body += doc.bestAnswer
    fn(body)
    ###

module.exports = Chiebukuro