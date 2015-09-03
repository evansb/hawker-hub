$          = require 'jquery'
React      = require 'react'
Router     = require 'react-router'
App        = require 'ampersand-app'
Home       = require './Home'
SingleFood = require './SingleFood'
Navbar     = require './Navbar'
Footer     = require './Footer'
Landing    = require './Landing'
{ Route, RouteHandler, NotFoundRoute, DefaultRoute } = Router

HawkerHub = React.createClass
  render: ->
    <div>
      <RouteHandler {...@props} />
      <Footer />
    </div>

routes =
  <Route name='app' path='/' handler={HawkerHub}>
    <DefaultRoute handler={Home} />
    <Route name='home' path='/home' handler={Home} />
    <Route name='landing' path='/landing' handler={Landing} />
    <Route name='food' path='/food/:id' handler={SingleFood} />
    <NotFoundRoute handler={Home} />
  </Route>

module.exports =
  render: (el) ->
    Router.run routes, (Handler, state) ->
      React.render <Handler query={state.query} />, el
