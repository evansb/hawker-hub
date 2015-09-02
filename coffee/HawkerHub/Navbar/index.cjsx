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
  handleChange: (e, idx)->
    if idx is 1 then UserAction.logout()
  render: ->
    menuItemStyle = { 'text-align': 'right' }
    underlineStyle = { display: 'none' }
    iconStyle = { display: 'none' }
    iconMenuItems = [
      { payload: '1', text: User.name },
      { payload: '2', text: 'Logout' }
    ]
    <UI.DropDownMenu ref="menu" underlineStyle={underlineStyle}
                     iconStyle={iconStyle} onChange={@handleChange}
                     menuItems={iconMenuItems} />

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
      <div className="four columns user-menu">
        { if @state.isLoggedIn then <LogoutButton /> else <LoginButton /> }
      </div>
    </div>
