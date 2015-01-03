express  = require 'express'
router = express.Router()

module.exports = (app) ->
  app.use '/', router

router.get '/contact', (req, res, next) ->
  res.render 'index',
    title: 'Contact Page'
