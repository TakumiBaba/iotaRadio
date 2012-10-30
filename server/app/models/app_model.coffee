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
  content:
    type: String
  date:
    type: Date


WeatherSchema = new Schema
  detail:
    type: String
  simple:
    type: String
  areaCode:
    type: String
  isMajor:
    type: Boolean
  prefecture:
    type: String
  name:
    type: String

ChiebukuroSchema = new Schema
  content:
    type: String
  category:
    type: String
  categoryId:
    type: String
  questionId:
    type: String
  bestAnswer:
    type: String
  parentCategoryId:
    type: String

WikipediaSchema = new Schema
  title:
    type: String
  content:
    type: String
  trend:
    type: String
  date:
    type: Date


module.exports =
  AppSchema: AppSchema
  App: mongoose.model 'apps', AppSchema

  NewsSchema: NewsSchema
  News: mongoose.model 'news', NewsSchema

  WeatherSchema: WeatherSchema
  Weather: mongoose.model 'weather', WeatherSchema

  ChiebukuroSchema: ChiebukuroSchema
  Chiebukuro: mongoose.model 'chiebukuro', ChiebukuroSchema

  WikipediaSchema: WikipediaSchema
  Wikipedia: mongoose.model 'wikipedia', WikipediaSchema
