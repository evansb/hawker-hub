$          = require 'jquery'
React      = require 'react'
Router     = require 'react-router'
App        = require 'ampersand-app'
Home       = require './Home'
SingleFood = require './SingleFood'
Navbar     = require './Navbar'
Footer     = require './Footer'

{ Route, RouteHandler, NotFoundRoute } = Router

HawkerHub = React.createClass
  render: ->
    <div>
      <header>
        <Navbar title={App.title()} />
      </header>
      <div className="container">
        <RouteHandler />
      </div>
      <Footer />
    </div>

routes =
  <Route name='app' path='/' handler={HawkerHub}>
    <Route name='home' path='/#' handler={Home} />
    <Route name='foodDetail' path='/food/:id' handler={SingleFood} />
    <NotFoundRoute handler={Home}/>
  </Route>

module.exports =
  render: (el) ->
    Router.run routes, (Handler) ->
      React.render <Handler />, el
