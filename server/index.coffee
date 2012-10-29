require 'coffee-script'
require 'colors'

process.env.NODE_ENV = process.env.NODE_ENV || 'development'

global._ = require 'underscore'
http     = require 'http'
express  = require 'express'
app      = express()
server   = http.createServer app
global.$ = require 'jQuery'
io       = require('socket.io').listen 3001

(require './config/config') app
(require './config/routes') app, io

server.listen app.get('port'), ->
  console.log "City listening on port #{app.get 'port'} in #{process.env.NODE_ENV} mode.".green