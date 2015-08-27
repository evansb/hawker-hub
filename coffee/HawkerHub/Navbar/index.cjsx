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
  render: ->
    <div className="navbar">
      <AddItemDialog ref="addDialog" />
      <div className="row title">
        <div className="container">
        <div className="four columns navbar-search">
          <SearchBar />
        </div>
        <div className="four columns navbar-menu">
            <UI.Tabs style={{
                height: '60px',
                fontSize: '16px'
            }}>
              <UI.Tab label="Latest" style={{
                height: '60px',
                fontSize: '16px'

            }}/>
              <UI.Tab label="Nearby" style={{
                height: '60px',
                fontSize: '16px'
            }}/>
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
      </div>
    </div>
