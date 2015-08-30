_       = require 'lodash'
React   = require 'react'
Modal   = require 'react-modal'
UI      = require 'material-ui'
Colors  = require 'material-ui/lib/styles/colors'
UITheme = require '../Common/UITheme'
FoodCardList = require '../Food/FoodCardList'
{Filter, FilterStore} = require '../../Entity/Filter'
FoodCard = require '../Food/FoodCard'
AddItem = require '../AddItem'
{ UserStore } = require '../../Entity/User'

AddButton = React.createClass
  render: ->
    child =
      <div className="row button-content">
        <div className="four columns button-icon">
          <UI.FontIcon className="material-icons"> add </UI.FontIcon>
        </div>
        <div className="eight columns button-text">
          Add Item
        </div>
      </div>
    <UI.FlatButton onClick={@props.onClick}
                   secondary={true} children={child} />

module.exports = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    addItemShown: false
    activeFilter: Filter.Latest
  componentWillMount: ->
    UserStore.listen (event) =>
      if event.value? and event.value is 'connected'
        @setState { name: UserStore.getName() }
    FilterStore.listen (newFilter) =>
      @setState { activeFilter: newFilter }
  showAddItem: (self) -> -> self.setState { addItemShown: true }
  hideAddItem: (self) -> -> self.setState { addItemShown: false }
  render: ->
    <div className="limit-width">
      <div className="row context-bar">
        <div className="ten columns">
          <h1>{@state.activeFilter.heading()}</h1>
        </div>
        <div className="two columns">
          <AddButton onClick={@showAddItem(this)}/>
        </div>
      </div>
      { if (@state.addItemShown) then <AddItem ref="addItem" /> }
      <FoodCardList />
    </div>
