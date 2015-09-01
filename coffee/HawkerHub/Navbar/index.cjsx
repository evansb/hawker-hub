React         = require 'react'
{Navigation}  = require 'react-router'
App           = require 'ampersand-app'
UI            = require 'material-ui'
Image         = require 'react-retina-image'
UITheme       = require '../Common/UITheme'
Icon          = require '../Common/MaterialIcon'
{ Filter, FilterAction } = require '../../Entity/Filter'
{ UserStore, UserAction, User } = require '../../Entity/User'

SearchBar = React.createClass
  render: ->
    <div className="search-bar">
      <UI.TextField hintText="Search HawkerHub" />
    </div>

LoginButton = React.createClass
  render: ->
    <div className="twelve columns login-div">
      <a className="login-button" onClick={-> UserAction.login()}>
        Login with Facebook
      </a>
    </div>

LogoutButton = React.createClass
  render: ->
    <div className="twelve columns login-div">
      <a className="login-button" onClick={-> UserAction.logout()}>
        {User.name}
      </a>
    </div>

module.exports = React.createClass
  mixins: [UITheme, Navigation]
  getInitialState: ->
    isLoggedIn: no
  componentWillMount: ->
    UserStore.listen (event) =>
      switch (event.name)
        when 'status'
          @setState { isLoggedIn: event.value is 'connected' }
  render: ->
    <div className="row title navbar">
      <div className="four columns navbar-search">
        <SearchBar />
      </div>
      <div className="four columns navbar-menu">
        <UI.Tabs>
          <UI.Tab label="Latest"
                  onActive={=> @transitionTo 'home', {}, {filter:'latest'}} />
          <UI.Tab label="Nearby"
                  onActive={=> @transitionTo 'home', {}, {filter:'nearby'}} />
        </UI.Tabs>
      </div>
      <div className="four columns navbar-user-status">
        { if @state.isLoggedIn then <LogoutButton /> else <LoginButton /> }
      </div>
    </div>
