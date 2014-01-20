class App.Views.Minesweeper extends Backbone.View
  el: '#grid'
  template: 'javascripts/templates/minesweeper_template.html'

  events:
    'click td'           : 'checkBomb'
    'click #image-button': 'validateGame'

  initialize: =>
    @cheat = []
    $(document).keypress (event) =>
      @cheatCode(String.fromCharCode(event.which))
    @render()

  validateGame: =>
    @clicked_counter = 0
    _.each @collection.models, (model) =>
      if model.get('clicked') == 1
        @clicked_counter++
    if @clicked_counter == 54
      @$el.find('button').first().html('<img src="/components/stylesheet/wink-face.png">')
      setTimeout =>
        @alertWon()
      ,100
    else
      @$el.find('button').first().html('<img src="/components/stylesheet/sad-face.png">')
      @viewAllBombs()
      setTimeout =>
        @alertLost()
      ,100

  alertWon: =>
    alert 'You WON!!'
    @collection.reset()
    @render()

  alertLost: =>
      alert 'You Lost'
      @collection.reset()
      @render()

  cheatCode: (event) =>
    @cheat.push event
    if @cheat[0] == 'r'
      if @cheat.length > 1
        if @cheat[1] == 'a'
          if @cheat.length > 2
            if @cheat[2] == 'm'
              if @cheat.length > 3
                if @cheat[3] == 'y'
                  if @cheat.join('') == 'ramy'
                    @cheat = []
                    @viewAllBombs()
                else
                  @cheat = []
            else
              @cheat = []
        else
          @cheat = []
    else
      @cheat = []

  viewAllBombs: =>
    all_bombs = @collection.where
      bomb: 1
    _.each all_bombs, (model) =>
      $('td[data-id="'+model.get('id')+'"]').html('<img src="/components/stylesheet/bomb.png">')
      $('td[data-id="'+model.get('id')+'"]').css('height', '28px')
      $('td[data-id="'+model.get('id')+'"]').css('width', '28px')

  render: =>
    @$el.load @template, =>
      @$el.find('tbody').append("<tr>")
     
      bomb_rand_ids = []
      while bomb_rand_ids.length < 10
        model_id = Math.floor((Math.random()*63)+1)
        if bomb_rand_ids.indexOf(model_id) == -1
          bomb_rand_ids.push model_id
      
      x = 1
      y = 1
      id = 1
      @grid_cells = 1
      while @grid_cells < 65
        if bomb_rand_ids.indexOf(id) != -1
          bomb = 1
        else
          bomb = 0
        if x > 8
          @$el.find('tbody').append("<tr>")
          y++
          x = 1
        @collection.add
          id  : id
          bomb: bomb
          x   : x
          y   : y
        x++
        id++
        @grid_cells++
        @addView @collection.last()
      
  addView: (model) =>
    cellItemView = new App.Views.CellItem
      model: model
    @$el.find('tbody').append(cellItemView.render().el)
  
  checkBomb: (event, x, y, id) =>
    if event
      x = $(event.currentTarget).data('x')
      y = $(event.currentTarget).data('y')
      @id = $(event.currentTarget).data('id')
      bomb = $(event.currentTarget).data('bomb')
    else
      @id = id

    if bomb == 1
      $('td[data-id="'+@id+'"]').html('<img src="/components/stylesheet/bomb.png">')
      $('td[data-id="'+@id+'"]').css('height', '28px')
      $('td[data-id="'+@id+'"]').css('width', '28px')
      alert 'it is a bomb'
      @collection.reset()
      @render()
    
    @bomb_counter = 0
    surroundingCells = @getSurroundingCells(x,y)
    _.each surroundingCells, (model) =>
      if model[0].get('bomb') == 1
        @bomb_counter++

    if @bomb_counter == 0
      _.each surroundingCells, (model) =>
        if model[0].get('clicked') == 0
          $('td[data-id="'+model[0].get('id')+'"]').html('<p class="test"> 0 </p>')
          $('td[data-id="'+model[0].get('id')+'"]').css('height', '28px')
          $('td[data-id="'+model[0].get('id')+'"]').css('width', '28px')
          model[0].set
            clicked: 1
          @checkBomb(false, model[0].get('x'), model[0].get('y'), model[0].get('id'))

    $('td[data-id="'+@id+'"]').html('<p class="test">'+@bomb_counter+'</p>')
    _.each @collection.models, (model) =>
      if model.get('id') == @id
        model.set
          clicked: 1

  getSurroundingCells: (x,y) =>
    surrounding_cells = []
    case1 = @collection.where
      x: x + 1
      y: y
    case2 = @collection.where
      x: x + 1
      y: y + 1
    case3 = @collection.where
      x: x + 1
      y: y - 1
    case4 = @collection.where
      x: x
      y: y - 1
    case5 = @collection.where
      x: x
      y: y + 1
    case6 = @collection.where
      x: x - 1
      y: y
    case7 = @collection.where
      x: x - 1
      y: y - 1
    case8 = @collection.where
      x: x - 1
      y: y + 1

    if case1.length == 1
      surrounding_cells.push case1
    if case2.length == 1
      surrounding_cells.push case2
    if case3.length == 1
      surrounding_cells.push case3
    if case4.length == 1
      surrounding_cells.push case4
    if case5.length == 1
      surrounding_cells.push case5
    if case6.length == 1
      surrounding_cells.push case6
    if case7.length == 1
      surrounding_cells.push case7
    if case8.length == 1
      surrounding_cells.push case8
    
    surrounding_cells
