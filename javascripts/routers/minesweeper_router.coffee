class App.Routers.AppRouter extends Backbone.Router

  routes:
    "": "minesweeper"

  minesweeper: =>
    model = new App.Models.AppModel
    collection = new App.Collections.AppCollection
    new App.Views.Minesweeper
      collection: collection
      model     : model


$(document).ready ->
  App.init()
