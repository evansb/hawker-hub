React         = require 'react'
App           = require 'ampersand-app'
UI            = require 'material-ui'
Image         = require 'react-retina-image'
UITheme       = require '../Common/UITheme'
Icon          = require '../Common/MaterialIcon'
{ Filter, FilterAction } = require '../../Entity/Filter'
{ UserStore, UserAction } = require '../../Entity/User'

SearchBar = React.createClass
  render: ->
    <div className="search-bar">
      <UI.TextField hintText="Search HawkerHub" />
    </div>

LoginButton = React.createClass
  mixins: [UITheme]
  render: ->
    <div className="twelve columns login-div">
      <a className="login-button" onClick={-> UserAction.login()}>Login with Facebook</a>
    </div>

LogoutButton = React.createClass
  mixins: [UITheme]
  render: ->
    <div className="twelve columns login-div">
      <a className="login-button" onClick={-> UserAction.logout()}>{UserStore.getName()}</a>
    </div>

module.exports = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    isLoggedIn: no
  toggleLeftNav: ->  @refs.addDialog.show()
  componentWillMount: ->
    UserStore.listen (event) =>
      switch (event.name)
        when 'status'
          @setState { isLoggedIn: event.value is 'connected' }
  latestTab: -> FilterAction.change Filter.Latest
  nearbyTab: -> FilterAction.change Filter.Nearby
  render: ->
    <div className="row title navbar">
      <div className="four columns navbar-search">
        <SearchBar />
      </div>
      <div className="four columns navbar-menu">
        <UI.Tabs>
          <UI.Tab label="Latest" style={{height:'60px'}}
                  onActive={@latestTab} />
          <UI.Tab label="Nearby" style={{height:'60px'}}
                  onActive={@nearbyTab} />
        </UI.Tabs>
      </div>
      <div className="four columns navbar-user-status">
        {
          if (@state.isLoggedIn is no)
            <LoginButton />
          else if (@state.isLoggedIn is yes)
            <LogoutButton />
        }
      </div>
    </div>
