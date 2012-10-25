$ ->
  context = new webkitAudioContext()
  source  = context.createBufferSource()
  source2 = context.createBufferSource()
  source.connect context.destination
  xhr = new XMLHttpRequest()
  xhr.open 'GET', 'http://localhost:3000/music/chime.mp3', true
  xhr.responseType = 'arraybuffer'
  xhr.onload = ()->
    buffer = context.createBuffer xhr.response, false
    source.buffer = buffer
    source.noteOn 0
  xhr.send()
  setInterval ()->
    xhr2 = new XMLHttpRequest()
    xhr2.open "GET", "http://localhost:3000/music/chime.mp3", true
    xhr2.responseType = 'arraybuffer'
    xhr2.onload = ()->
      source2.connect context.destination
      buffer = context.createBuffer xhr2.response, false
      source2.buffer = buffer
      source2.noteOn 0
    xhr2.send()
  , 5000