_       = require 'lodash'
React   = require 'react'
Modal   = require 'react-modal'
UI      = require 'material-ui'
Colors  = require 'material-ui/lib/styles/colors'
UITheme = require '../Common/UITheme'
FoodCardList = require '../Food/FoodCardList'
Filter = require '../../Entity/Filter'
FoodCard = require '../Food/FoodCard'
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
    <UI.FlatButton secondary={true} children={child} />

module.exports = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    modalIsOpen: false
    modalModel: null
    items: []
    name: UserStore.getName() or 'My'
  componentWillMount: ->
    UserStore.listen (event) =>
      if event.value? and event.value is 'connected'
        @setState { name: UserStore.getName() }
  handleMoreClick: (model) ->
    @setState { modalIsOpen: true, modalModel: model }
  handleCancel: -> @setState { modalIsOpen: false }
  show: -> @setState { modalIsOpen: true}
  render: ->
    <div className="limit-width">
      <Modal className="food-card-detail"
             isOpen = { @state.modalIsOpen }
             onRequestClose = { @handleCancel }
             ref="dialog" modal={false}>
        <FoodCard ref="foodDetail" model={@state.modalModel} />
      </Modal>
      <div className="row context-bar">
        <div className="ten columns">
          <h1>Recent Items</h1>
        </div>
        <div className="two columns">
          <AddButton />
        </div>
      </div>
      <FoodCardList fetch={Filter.Nearby} handleMoreClick={@handleMoreClick} />
    </div>
