React         = require 'react'
App           = require 'ampersand-app'
UI            = require 'material-ui'
Image         = require 'react-retina-image'
AddItemDialog = require '../AddItem'
UITheme       = require '../Common/UITheme'
Icon          = require '../Common/MaterialIcon'
{ UserStore, UserAction } = require '../../Entity/User'

menuItems = [
  { route: 'home', text: 'Home', leftIcon: <Icon name="home"/> },
  { route: 'schedule', text: 'Schedule' }
  { route: 'collection', text: 'Collections' },
  { route: 'food-basket', text: 'Food Basket' }
]

LeftNavToggle = React.createClass
  propTypes:
    handleClick: React.PropTypes.func.isRequired
  render: ->
    <Icon name="add" overrideColor="white" onClick={@props.handleClick} />

SearchBar = React.createClass
  render: ->
    <div className="search-bar">
      <UI.TextField hintText="Search HawkerHub" />
    </div>

LogoutButton = React.createClass
  mixins: [UITheme]
  render: ->
    <div className="eleven columns">
       <UI.FlatButton label={UserStore.getName()} onClick={-> UserAction.logout()} />
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
  render: ->
    <div className="navbar">
      <AddItemDialog ref="addDialog" />
      <div className="row title">
        <div className="one columns navbar-add">
          <LeftNavToggle handleClick={@toggleLeftNav} />
        </div>
        <div className="four columns navbar-search">
          <SearchBar />
        </div>
        <div className="three columns navbar-menu">
          <UI.FlatButton label="Me" />
          <UI.FlatButton label="Nearby" />
        </div>
        <div className="three columns navbar-user-status">
          { if (@state.isLoggedIn is no)
              <UI.FlatButton label="Login with Facebook"
                         onClick={-> UserAction.login()} />
            else if (@state.isLoggedIn is yes) 
              <LogoutButton />
            }
        </div>
      </div>
    </div>
