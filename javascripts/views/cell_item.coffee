class App.Views.CellItem extends Backbone.View

  tagName: 'tr'
  el: '#grid-view'

  render: =>
    @$el.find('tr:last').append('<td>')
    @$el.find('td:last').attr('data-id', @model.get('id'))
    @$el.find('td:last').attr('data-x', @model.get('x'))
    @$el.find('td:last').attr('data-y', @model.get('y'))
    @$el.find('td:last').attr('data-bomb', @model.get('bomb'))
    @$el.find('td:last').html('<div><button>')
