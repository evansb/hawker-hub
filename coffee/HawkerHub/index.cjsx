$          = require 'jquery'
React      = require 'react'
Router     = require 'react-router'
App        = require 'ampersand-app'
Modal      = require 'react-modal'
Home       = require './Home'
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
      <footer>
        <Footer />
      </footer>
    </div>

routes =
  <Route name='app' path='/' handler={HawkerHub}>
    <Route name='home' path='/#' handler={Home} />
    <Route name='foodDetail' path='/food/:id' handler={Home} />
    <NotFoundRoute handler={Home}/>
  </Route>

module.exports =
  render: (el) ->
    Router.run routes, (Handler) ->
      Modal.setAppElement el
      Modal.injectCSS()
      React.render <Handler />, el
