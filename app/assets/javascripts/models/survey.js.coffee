class Ask.Survey extends Batman.Model
  @storageKey: 'surveys'
  @persist Batman.RailsStorage

  @hasMany 'questions'

  @encode 'name', 'active'

