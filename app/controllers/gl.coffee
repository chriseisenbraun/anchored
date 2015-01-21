express  = require 'express'
router = express.Router()

module.exports = (app) ->
  app.use '/', router

router.get '/gl', (req, res, next) ->
  res.render 'gl',
    title: 'GL'
