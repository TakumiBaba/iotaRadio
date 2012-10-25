fs = require 'fs'
module.exports = ()->
  return{
    get: (area)->
      weatherDir = "./public/weather_channel/"
      aCodeList = fs.readdirSync weatherDir
      body = ""
      detailList = []
      prefCode = @getPrefecturesData()
      prefRegExp = new RegExp area
      _.each prefCode, (data)->
        if data.prefecture.match prefRegExp
          _.each data.cities, (city)->
            detailList.push city.code
      _.each aCodeList, (aCode)->
        detailFlag = false
        _.each detailList, (d)->
          d = String d
          aCode = String aCode
          if d is aCode
            detailFlag = true
        if detailFlag is true
          body += fs.readFileSync weatherDir+aCode+"/detail.txt"
        else
          body += fs.readFileSync weatherDir+aCode+"/simple.txt"

      return body

    reload: ()->
      _.each getPrefecturesData(), (d)->
        p = d.prefecture
        _.each d.cities, (value, key)->
          set(p, key, value.code)

    set: (pName, cName, aCode)->
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

    getPrefecturesData: ()->
      return @prefecturesData
    prefecturesData:
      1:{
        prefecture:"北海道"
        cities:
          "札幌":code:1400,isMajor:true
          "稚内":code:1100
          "旭川":code:1200
          "留萌":code:1300
          "岩見沢":code:1500
          "倶知安":code:1600
          "網走":code:1710
          "北見":code:1720
          "紋別":code:1730
          "根室":code:1800
          "釧路":code:1900
          "帯広":code:2000
          "室蘭":code:2100
          "浦河":code:2200
          "函館":code:2300
          "江差":code:2400

      }
      2:{
        prefecture:"青森県"
        cities:
          "青森":code:3110,isMajor:true
          "むつ":code:3120
          "八戸":code:3130

      }
      3:{
        prefecture:"岩手県"
        cities:
          "盛岡":code:3310,isMajor:true
          "宮古":code:3320
          "大船渡":code:3330

      }
      4:{
        prefecture:"宮城県"
        cities:
          "仙台":code:3410,isMajor:true
          "白石":code:3420

      }
      5:{
        prefecture:"秋田県"
        cities:
          "秋田":code:3210,isMajor:true
          "横手":code:3220

      }
      6:{
        prefecture:"山形県"
        cities:
          "山形":code:3510,isMajor:true
          "米沢":code:3520
          "酒田":code:3530
          "新庄":code:3540

      }
      7:{
        prefecture:"福島県"
        cities:
          "福島":code:3610,isMajor:true
          "小名浜":code:3620
          "若松":code:3630

      }
      8:{
        prefecture:"茨木県"
        cities:
          "水戸":code:4010,isMajor:true
          "土浦":code:4020

      }
      9:{
        prefecture:"栃木県"
        cities:
          "宇都宮":code:4110,isMajor:true
          "大田原":code:4120

      }
      10:{
        prefecture:"群馬県"
        cities:
          "前橋":code:4210,isMajor:true
          "みなかみ":code:4220

      }
      11:{
        prefecture:"埼玉県"
        cities:
          "さいたま":code:4310,isMajor:true
          "熊谷":code:4320
          "秩父":code:4330

      }
      12:{
        prefecture:"千葉県"
        cities:
          "千葉":code:4510,isMajor:true
          "銚子":code:4520
          "館山":code:4530

      }
      13:{
        prefecture:"東京都"
        cities:
          "東京":code:4410,isMajor:true
          "大島":code:4420
          "八丈島":code:4430
          "父島":code:4440

      }
      14:{
        prefecture:"神奈川県"
        cities:
          "横浜":code:4610,isMajor:true
          "小田原":code:4620

      }
      15:{
        prefecture:"新潟県"
        cities:
          "新潟":code:5410,isMajor:true
          "長岡":code:5420
          "高田":code:5430
          "相川":code:5440

      }
      16:{
        prefecture:"富山県"
        cities:
          "富山":code:5510,isMajor:true
          "伏木":code:5520

      }
      17:{
        prefecture:"石川県"
        cities:
          "金沢":code:5610,isMajor:true
          "輪島":code:5620

      }
      18:{
        prefecture:"福井県"
        cities:
          "福井":code:5710,isMajor:true
          "敦賀":code:5720

      }
      19:{
        prefecture:"山梨県"
        cities:
          "甲府":code:4910,isMajor:true
          "河口湖":code:4920

      }
      20:{
        prefecture:"長野県"
        cities:
          "長野":code:4810,isMajor:true
          "松本":code:4820
          "飯田":code:4830

      }
      21:{
        prefecture:"岐阜県"
        cities:
          "岐阜":code:5210,isMajor:true
          "高山":code:5220

      }
      22:{
        prefecture:"静岡県"
        cities:
          "静岡":code:5010,isMajor:true
          "網代":code:5020
          "三島":code:5030
          "浜松":code:5040

      }
      23:{
        prefecture:"愛知県"
        cities:
          "名古屋":code:5110,isMajor:true
          "豊橋":code:5120

      }
      24:{
        prefecture:"三重県"
        cities:
          "津":code:5210,isMajor:true
          "尾鷲":code:5220

      }
      25:{
        prefecture:"滋賀県"
        cities:
          "大津":code:6010,isMajor:true
          "彦根":code:6020

      }
      26:{
        prefecture:"京都府"
        cities:
          "京都":code:6110,isMajor:true
          "舞鶴":code:"0400"

      }
      27:{
        prefecture:"大阪府"
        cities:
          "大阪":code:6200,isMajor:true

      }
      28:{
        prefecture:"兵庫県"
        cities:
          "神戸":code:6310,isMajor:true
          "豊岡":code:6320

      }
      29:{
        prefecture:"奈良県"
        cities:
          "奈良":code:6410,isMajor:true
          "風屋":code:6420

      }
      30:{
        prefecture:"和歌山県"
        cities:
          "和歌山":code:6510,isMajor:true
          "潮岬":code:6520

      }
      31:{
        prefecture:"鳥取県"
        cities:
          "鳥取":code:6910,isMajor:true
          "米子":code:6920

      }
      32:{
        prefecture:"島根県"
        cities:
          "松江":code:6810,isMajor:true
          "浜田":code:6820
          "西郷":code:6830

      }
      33:{
        prefecture:"岡山県"
        cities:
          "岡山":code:6610,isMajor:true
          "津山":code:6620

      }
      34:{
        prefecture:"広島県"
        cities:
          "広島":code:6710,isMajor:true
          "庄原":code:6720

      }
      35:{
        prefecture:"山口県"
        cities:
          "山口":code:8120,isMajor:true
          "下関":code:8110
          "柳井":code:8130
          "萩":code:8140

      }
      36:{
        prefecture:"徳島県"
        cities:
          "徳島":code:7110,isMajor:true
          "日和佐":code:7120

      }
      37:{
        prefecture:"香川県"
        cities:
          "高松":code:7200,isMajor:true

      }
      38:{
        prefecture:"愛媛県"
        cities:
          "松山":code:7310,isMajor:true
          "新居浜":code:7320
          "宇和島":code:7330

      }
      39:{
        prefecture:"高知県"
        cities:
          "高知":code:7410,isMajor:true
          "室戸":code:7420
          "清水":code:7430

      }
      40:{
        prefecture:"福岡県"
        cities:
          "福岡":code:8210,isMajor:true
          "八幡":code:8220
          "飯塚":code:8230
          "久留米":code:8240

      }
      41:{
        prefecture:"佐賀県"
        cities:
          "佐賀":code:8510,isMajor:true
          "伊万里":code:8520

      }
      42:{
        prefecture:"長崎県"
        cities:
          "長崎":code:8410,isMajor:true
          "佐世保":code:8420
          "厳原":code:8430
          "福江":code:8440

      }
      43:{
        prefecture:"熊本県"
        cities:
          "熊本":code:8610,isMajor:true
          "阿蘇乙姫":code:8620
          "牛深":code:8630
          "人吉":code:8640

      }
      44:{
        prefecture:"大分県"
        cities:
          "大分":code:8310,isMajor:true
          "中津":code:8320
          "日田":code:8330
          "佐伯":code:8340

      }
      45:{
        prefecture:"宮崎県"
        cities:
          "宮崎":code:8710,isMajor:true
          "延岡":code:8720
          "都城":code:8730
          "高千穂":code:8740

      }
      46:{
        prefecture:"鹿児島県"
        cities:
          "鹿児島":code:8810,isMajor:true
          "鹿屋":code:8820
          "西之表":code:8830
          "名瀬":code:1000

      }
      47:{
        prefecture:"沖縄県"
        cities:
          "那覇":code:9110,isMajor:true
          "名護":code:9120
          "久米島":code:9130
          "南大東島":code:9200
          "宮古島":code:9300
          "石垣島":code:9410
          "与那国島":code:9420

      }
  }