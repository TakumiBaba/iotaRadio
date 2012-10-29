class Chiebukuro
  category_list:
    2078297513:"エンターテインメントと趣味"
    2078297937:"'暮らしと生活ガイド"
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
    2078297353:"おしゃべり、雑談"

  constructor:()->
    console.log 'construct'
    @mongoose = require 'mongoose'
    @APP_ID = "QgolUhOxg66v9Cjr795kmpFfbGT9il5vtJev3DeQ2U_c6cylTHE1dOiYeoQj1Bg-"
    @address = "http://chiebukuro.yahooapis.jp/Chiebukuro/V1/getNewQuestionList"
    @params = "&condition=solved&sort=-anscount&output=json"

  set:()->
    console.log @category_list
    _.each @category_list, (categoryname, categoryid)=>
      $.ajax
        url: @address+"?appid="+@APP_ID+@params+"&category_id="+categoryid
        type:"GET"
        success:(data)=>
          results = data.ResultSet.Result
          chiebukuroModel = @mongoose.model 'chiebukuro'
          _.each results, (result)->
            chiebukuroModel.find questionId: result.questionId, (err, docs)=>
              if err
                throw err
              if docs.length == 0
                instance = new chiebukuroModel()
                instance.questionId = result.questionId
                instance.content = result.Content
                instance.category = result.Category
                instance.categoryId = result.categoryId
                instance.bestAnswer = result.BestAnswer
                instance.save (err)->
                  if err
                    throw err
                  else
                    console.log 'success'
        error:(err)->
          console.log err

  get:()->
    chiebukuroModel = @mongoose.model 'chiebukuro'
    _.each @category_list, (categoryname, categoryid)=>
      chiebukuroModel.find {}, (err, docs)->


module.exports = Chiebukuro