express  = require 'express'
router = express.Router()

module.exports = (app) ->
  app.use '/', router

router.get '/about', (req, res, next) ->
  res.render 'index',
    title: 'About Page'
