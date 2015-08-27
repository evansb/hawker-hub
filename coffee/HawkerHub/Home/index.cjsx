_       = require 'lodash'
React   = require 'react'
Modal   = require 'react-modal'
UI      = require 'material-ui'
Colors  = require 'material-ui/lib/styles/colors'
UITheme = require '../Common/UITheme'
FoodCardList = require '../Food/FoodCardList'
Filter = require '../../Entity/Filter'
FoodCardDetail = require '../Food/FoodCardDetail'
{ UserStore } = require '../../Entity/User'

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
    <div>
      <Modal className="food-card-detail"
             isOpen = { @state.modalIsOpen }
             onRequestClose = { @handleCancel}
             ref="dialog" modal={false}>
        <FoodCardDetail ref="foodDetail" model={@state.modalModel} />
      </Modal>
      <div className="row limit-width context-title">
        <a href="#">Add an item</a>
        <hr/>
      </div>
      <FoodCardList className="limit-width"
                    fetch={Filter.Nearby}
                    handleMoreClick={@handleMoreClick} />
    </div>
