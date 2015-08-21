$      = require 'jquery'
React  = require 'react'
Router = require 'react-router'
App    = require 'ampersand-app'

NavBar     = require './NavBar'
Collection = require './Collection'
Dashboard  = require './Dashboard'
Home       = require './Home'

{ Route, RouteHandler, NotFoundRoute } = Router

HawkerHub = React.createClass
  render: ->
    <div>
      <header>
        <NavBar title={App.title()}/>
      </header>
      <RouteHandler />
    </div>

routes =
  <Route name='app' path='/' handler={HawkerHub}>
    <Route name='home' path='/#' handler={Home} />
    <Route name='collection' path='/dashboard' handler={Dashboard} />
    <Route name='dashboard'  path='/collection' handler={Collection} />
    <NotFoundRoute handler={Home}/>
  </Route>

module.exports =
  render: (el) ->
    Router.run routes, (Handler) ->
      React.render <Handler />, el
