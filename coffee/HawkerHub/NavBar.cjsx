React      = require 'react'
App        = require 'ampersand-app'
UI         = require 'material-ui'
Image      = require 'react-retina-image'
UITheme    = require './Common/UITheme'
Icon       = require './Common/MaterialIcon'
MenuBar    = require './MenuBar'
AddItemDialog = require './AddItemDialog'

menuItems = [
  { route: 'home', text: 'Home', leftIcon: <Icon name="home"/> },
  { route: 'schedule', text: 'Schedule' }
  { route: 'collection', text: 'Collections' },
  { route: 'food-basket', text: 'Food Basket' }
]

RightNavToggle = React.createClass
  render: ->
    <UI.IconButton onClick={@props.handleClick} iconClassName="material-icons">
      menu
    </UI.IconButton>

LeftNavToggle = React.createClass
  propTypes:
    handleClick: React.PropTypes.func.isRequired
  render: ->
    <Icon name="add" onClick={@props.handleClick} />

SearchBar = React.createClass
  render: ->
    <div className="search-bar">
      <UI.TextField hintText="Search for Menu, Stall, or People" />
    </div>

module.exports = React.createClass
  mixins: [UITheme]
  toggleLeftNav: -> @refs.addDialog.show()
  render: ->
    <div>
      <AddItemDialog ref="addDialog" />
      <div className="row title">
        <div className="two columns">
          <div className="row">
            <div className="two columns">
              <LeftNavToggle handleClick={@toggleLeftNav} />
            </div>
            <div className="ten columns">
              <SearchBar />
            </div>
          </div>
        </div>
      </div>
    </div>
