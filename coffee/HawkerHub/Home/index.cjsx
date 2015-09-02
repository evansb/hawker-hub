_       = require 'lodash'
React   = require 'react'
Modal   = require 'react-modal'
UI      = require 'material-ui'
Colors  = require 'material-ui/lib/styles/colors'
UITheme = require '../Common/UITheme'
FoodCardList = require '../Food/FoodCardList'
FoodCard = require '../Food/FoodCard'
AddItem = require '../AddItem'
{ User, UserStore } = require '../../Entity/User'
{ FilterStore, FilterAction } = require '../../Entity/Filter'
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
    heading: ""
    addItemShown: false
    hasLoggedIn: false
  componentWillReceiveProps: (nextProps) ->
    sameFilter = @props.query.filter is nextProps.query.filter
    if (not sameFilter) then FilterAction.change nextProps.query.filter
  componentWillMount: ->
    FilterStore.listen (filter) =>
      @setState { heading: filter.heading() }
    UserStore.listen (event) =>
      if event.value? and event.value is 'connected'
        FilterAction.change 'latest'
        @setState { name: User.name, hasLoggedIn: true }
      if event.value? and event.value is 'logged_out'
        location.reload()
        @setState { name: null, hasLoggedIn: false }
    FoodStore.listen (event) =>
      if event.name is 'created' then @setState { addItemShown: false }
  showAddItem: (self) -> -> self.setState { addItemShown: true }
  hideAddItem: (self) -> -> self.setState { addItemShown: false }
  render: ->
    buttonShown =
      if (@state.hasLoggedIn && !@state.addItemShown)
        <AddButton onClick={@showAddItem(this)}/>
      else if (@state.hasLoggedIn)
        <CloseAddButton onClick={@hideAddItem(this)}/>
    <div className="limit-width">
      {
        if (@state.hasLoggedIn)
          <div className="row context-bar">
            <div className="ten columns">
              <h1>{@state.heading}</h1>
            </div>
            <div className="two columns">{buttonShown}</div>
          </div>
        else
          <h1>This is the landing page</h1>
      }
      { if (@state.addItemShown) then <AddItem ref="addItem" /> }
      { if (@state.hasLoggedIn) then <FoodCardList ref="list" /> }
    </div>
