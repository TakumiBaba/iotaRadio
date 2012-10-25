mongoose = require 'mongoose'
Schema   = mongoose.Schema

AppSchema = new Schema
  title:
    type: String
  content:
    type: String

NewsSchema = new Schema
  title:
    type: String
  keyword:
    type: String
  topicname:
    type: String
  category:
    type: String
  date:
    type: Date
  url:
    type: String
  audio_url:
    type: String

module.exports =
  AppSchema: AppSchema
  App: mongoose.model 'apps', AppSchema
  NewsSchema: NewsSchema
  News: mongoose.model 'news', NewsSchema
