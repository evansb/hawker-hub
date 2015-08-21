React      = require 'react'
App        = require 'ampersand-app'
{Cell}     = require 'react-pure'
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

LeftNavToggle = React.createClass
  render: ->
    <UI.IconButton onClick={@props.handleClick} iconClassName="material-icons">
      menu
    </UI.IconButton>

AddItemButton = React.createClass
  propTypes:
    onClick: React.PropTypes.func.isRequired
  render: ->
    <Icon name="add" onClick={@props.handleClick}/>

SearchBar = React.createClass
  render: ->
    <UI.TextField hintText="Search for Menu, Stall, or People" />

module.exports = React.createClass
  mixins: [UITheme]
  toggleLeftNav: -> @refs.leftNav.toggle()
  showAddDialog: -> @refs.addDialog.show()
  render: ->
    Title =
      <Cell className="title">
        <SearchBar />
      </Cell>
    <div>
      <UI.LeftNav ref="leftNav" docked={false} menuItems={menuItems} />
      <AddItemDialog ref="addDialog" />
      <UI.AppBar
        title={Title}
        iconElementLeft={<LeftNavToggle handleClick={@toggleLeftNav} />}
        iconElementRight={ <Icon name="add" onClick={@showAddDialog} /> } />
    </div>
