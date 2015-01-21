express  = require 'express'
router = express.Router()

module.exports = (app) ->
  app.use '/', router

router.get '/project', (req, res, next) ->
  res.render 'project'
