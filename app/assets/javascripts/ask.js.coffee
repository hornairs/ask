window.Ask = class Ask extends Batman.App

  # @route '/controller/:id', 'controller#show', resource: 'model', action: 'show'
  @resources 'survey'
  @root 'dashboard#index'

  @on 'run', ->
    console?.log "Running ...."

  @on 'ready', ->
    console?.log "Ask ready for use."

  @flash: Batman()
  @flash.accessor
    get: (key) -> @[key]
    set: (key, value) ->
      @[key] = value
      if value isnt ''
        setTimeout =>
          @set(key, '')
        , 2000
      value

  @flashSuccess: (message) -> @set 'flash.success', message
  @flashError: (message) ->  @set 'flash.error', message
