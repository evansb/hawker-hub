_       = require 'lodash'
React   = require 'react'
FoodCard = require '../Food/FoodCard'
{ SingleFoodStore, SingleFoodAction } = require '../../Entity/SingleFood'

module.exports = React.createClass
  getInitialState: -> { food: null }
  contextTypes:
    router: React.PropTypes.func
  componentWillMount: ->
    id = @context.router.getCurrentParams().id
    SingleFoodStore.listen (food) => @setState { food }
    SingleFoodAction.fetch id
  render: ->
    <div className="limit-width">
      { if (@state.food) then <FoodCard model={@state.food} /> }
    </div>
