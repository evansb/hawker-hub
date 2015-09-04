React         = require 'react'
{Navigation}  = require 'react-router'
App           = require 'ampersand-app'
UI            = require 'material-ui'
UITheme       = require '../Common/UITheme'
Icon          = require '../Common/MaterialIcon'
{ FilterAction } = require '../../Entity/Filter'
{ UserStore, UserAction, User } = require '../../Entity/User'

SearchBar = React.createClass
  getInitialState: -> { waiting: false }
  handleBlur: ->
    if (@refs.term.getValue().trimLeft().length == 0)
      FilterAction.revert()
  clear: -> @refs.term.setValue ''
  handleChange: (self) -> ->
    if (self.refs.term.getValue().trimLeft().length == 0)
      FilterAction.revert()
    else
      while (self.waiting)
        1
      setTimeout (=>
        FilterAction.change {name: 'search', arg: self.refs.term.getValue() }
        self.setState { waiting: false }
      ), 500
      self.setState { waiting: true }
  render: ->
    <div className="search-bar">
      <UI.TextField hintText="Search HawkerHub" ref="term"
                    onBlur={@handleBlur} onChange={@handleChange(this)} />
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
  getInitialState: -> name: User.name
  componentWillMount: ->
    UserStore.listen (event) =>
      switch event
        when 'hub_login_success'
          @setState { name: User.name }
  render: ->
    menuItemStyle = { 'textAlign': 'right' }
    underlineStyle = { display: 'none' }
    iconStyle = { display: 'none' }
    iconMenuItems = [
      { payload: '1', text: @state.name },
      { payload: '2', text: 'Logout' }
    ]
    <UI.DropDownMenu ref="menu" underlineStyle={underlineStyle}
                     iconStyle={iconStyle} onChange={@handleChange}
                     menuItems={iconMenuItems} />

module.exports = React.createClass
  mixins: [UITheme, Navigation]
  getInitialState: -> { isLoggedIn: false }
  componentWillMount: ->
    UserStore.listen (event) =>
      switch event
        when 'hub_login_success'
          @setState { isLoggedIn: true }
        when 'hub_logout_success'
          @setState { isLoggedIn: false }
  render: ->
    initialIndex = if @props.query.filter is 'nearby' then 1 else 0
    normalNavbar =
      <div className="row title navbar">
        { if @state.isLoggedIn
            <div className="four columns navbar-search">
              <SearchBar ref="searchBar" />
            </div>
        }
        { if @state.isLoggedIn
            <div className="four columns navbar-menu">
              <UI.Tabs initialSelectedIndex={initialIndex}
                  onChange={(v) =>
                    v = if v is 0 then 'latest' else 'nearby'
                    @refs.searchBar.clear()
                    @transitionTo 'home',{}, {filter:v}}>
                <UI.Tab label="Latest" value='latest' />
                <UI.Tab label="Nearby" value='nearby' />
              </UI.Tabs>
            </div>
        }

        <div className="four columns user-menu">
          { if @state.isLoggedIn then <LogoutButton /> }
        </div>
     </div>
    { if (@props.params && @props.params.id is 'privacy')
        normalNavbar
      else
        <div></div> }
