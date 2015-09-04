$          = require 'jquery'
URL        = require 'url'
Reflux     = require 'reflux'

LocationAction = Reflux.createActions ['geocode']

key = 'AIzaSyCaW5bu4DFvl_zg69zHVJH2XFJBCD7D76A'
location_type = 'rooftop'

LocationStore = Reflux.createStore
  listenables: LocationAction

  onGeocode: (options) ->
    {id, lat, long} = options
    latlng = "#{lat},#{long}"
    url = URL.format
      protocol: 'https'
      hostname: "maps.googleapis.com/maps/api/geocode/json"
      query: {latlng, key, location_type}
    $.ajax
      type: 'GET'
      dataType: 'json'
      crossOrigin: true
      url: url
      success: (data) =>
        if (data.status is "OK")
          @trigger {id, status: 'success', address: data.results[0].formatted_address }
        else
          @trigger {id, status: 'failure'}
      error: (e) =>
        @trigger {id, status: 'failure'}

module.exports = { LocationStore, LocationAction }
