express  = require 'express'
router = express.Router()

module.exports = (app) ->
  app.use '/', router

router.get '/projects', (req, res, next) ->
  res.render 'projects'
