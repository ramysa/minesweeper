window.App =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  vent: _.extend {}, Backbone.Events

  init: =>
    new App.Routers.AppRouter
    Backbone.history.start()

  template: (id) =>
    _.template $(id)

