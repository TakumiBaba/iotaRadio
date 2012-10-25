$ ->

  context = new webkitAudioContext()
  source = context.createBufferSource()

  socket = io.connect "http://localhost:3000/"
  socket.emit "news"
  socket.on "reverse_news", (data)->
    iframe = $("<iframe></iframe>")
    url = 'http://translate.google.com/translate_tts?tl=ja&q=拉致被害者の蓮池薫さん（55）がこのほど時事通信社のインタビューに応じ、2002年10月の帰国前に北朝鮮当局から、'
    iframe.attr "src", url
    $('body').append iframe
###
  lang = 'ja'
  tts_url = "http://translate.google.com/translate_tts?tl="+lang+"&q="
  tts_utterance = encodeURIComponent "こんばんわー！"
  tts_url += tts_utterance
  console.log "tts_url="+tts_url

  context = new webkitAudioContext()
  source  = context.createBufferSource()
  music   = context.createBufferSource()

  bufferLoader = new BufferLoader(
    context
    ["http://translate.google.com/translate_tts?tl=ja&q=%E3%81%93%E3%82%93%E3%81%B0%E3%82%93%E3%82%8F"]
    (bufferList)->

      source.buffer = bufferList[0]
      source.connect context.destination
      source.noteOn 0

      music.buffer = bufferList[0]
      music.connect context.destination
      music.noteOn 10
  )

  #bufferLoader.load()


  xhr = new XMLHttpRequest()
  xhr.open "GET", tts_url, true
  xhr.responseType = "arrayBuffer"

  xhr.onload = ()->
    context.decodeAudioData xhr.response, (buffer)->
      source.buffer = buffer
      source.connect context.destination
      source.noteOn 0

  xhr.send()
###