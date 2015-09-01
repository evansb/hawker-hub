_       = require 'lodash'
React   = require 'react'
Modal   = require 'react-modal'
UI      = require 'material-ui'
Colors  = require 'material-ui/lib/styles/colors'
UITheme = require '../Common/UITheme'
FoodCardList = require '../Food/FoodCardList'
Filter = require '../../Entity/Filter'
FoodCard = require '../Food/FoodCard'
AddItem = require '../AddItem'
{ User, UserStore } = require '../../Entity/User'
{ FoodStore } = require '../../Entity/Food'

AddButton = React.createClass
  render: ->
    child =
      <div className="row button-content">
        <div className="four columns button-icon">
          <UI.FontIcon className="material-icons">add</UI.FontIcon>
        </div>
        <div className="eight columns button-text">Add Item</div>
      </div>
    <UI.FlatButton onClick={@props.onClick} secondary={true} children={child} />

CloseAddButton = React.createClass
  render: ->
    child =
      <div className="row button-content">
        <div className="four columns button-icon">
          <UI.FontIcon className="material-icons">close</UI.FontIcon>
        </div>
        <div className="eight columns button-text">
          Close
        </div>
      </div>
    <UI.FlatButton onClick={@props.onClick} secondary={true} children={child} />

module.exports = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    name: null
    addItemShown: false
    hasLoggedIn: false
  componentWillMount: ->
    UserStore.listen (event) =>
      if event.value? and event.value is 'connected'
        @setState { name: User.name, hasLoggedIn: true }
    FoodStore.listen (event) =>
      if event.name is 'created' then @setState { addItemShown: false }
  showAddItem: (self) -> -> self.setState { addItemShown: true }
  hideAddItem: (self) -> -> self.setState { addItemShown: false }
  componentDidMount: ->
    console.log @props.query.filter
  render: ->
    buttonShown =
      if (@state.hasLoggedIn && !@state.addItemShown)
        <AddButton onClick={@showAddItem(this)}/>
      else if (@state.hasLoggedIn)
        <CloseAddButton onClick={@hideAddItem(this)}/>
    filter = Filter.get @props.query.filter or 'latest'
    <div className="limit-width">
      <div className="row context-bar">
        <div className="ten columns">
          <h1>{filter.heading()}</h1>
        </div>
        <div className="two columns">{buttonShown}</div>
      </div>
      { if (@state.addItemShown) then <AddItem ref="addItem" /> }
      { if (@state.hasLoggedIn) then <FoodCardList filter={filter} /> }
    </div>
