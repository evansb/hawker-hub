$          = require 'jquery'
React      = require 'react'
Router     = require 'react-router'
App        = require 'ampersand-app'
Home       = require './Home'
SingleFood = require './SingleFood'
Navbar     = require './Navbar'
Footer     = require './Footer'
Landing    = require './Landing'
{ UserStore, UserAction } = require '../Entity/User'
{ FacebookStore } = require '../Entity/Facebook'
{ Route, RouteHandler, NotFoundRoute, DefaultRoute } = Router

HawkerHub = React.createClass
  render: ->
    <div>
      <header><Navbar /></header>
      <RouteHandler {...@props} />
      <Footer />
    </div>

HomeorLanding = React.createClass
  getInitialState: ->
    hasLoggedIn: false
    fbLogin: false
  componentWillMount: ->
    UserStore.listen (e) =>
      switch e
        when 'fb_login_success'
          @setState { fbLogin: true }
        when 'hub_login_success'
          @setState { hasLoggedIn: true }
        when 'hub_logout_success'
          @setState { hasLoggedIn: false }
    FacebookStore.listen (e) =>
      if e is 'ready' then UserAction.status()
  render: ->
    <div>
    { if @state.hasLoggedIn
        <Home params={@props.params} />
      else
        <Landing fbLogin={@state.fbLogin} /> }
    </div>

routes =
  <Route name='app' path='/' handler={HawkerHub}>
    <DefaultRoute handler={HomeorLanding} />
    <Route name='home' path='/home' handler={HomeorLanding} />
    <Route name='food' path='/food/:id' handler={HomeorLanding} />
    <NotFoundRoute handler={Landing} />
  </Route>

module.exports =
  render: (el) ->
    Router.run routes, (Handler, state) ->
      React.render <Handler query={state.query} />, el
