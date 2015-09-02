_       = require 'lodash'
React   = require 'react'
FoodCard = require '../Food/FoodCard'
{ SingleFoodStore, SingleFoodAction } = require '../../Entity/SingleFood'

module.exports = React.createClass
  getInitialState: -> { food: null }
  componentWillMount: ->
    id = @props.param.id
    SingleFoodStore.listen (food) => @setState { food }
    SingleFoodAction.fetch id
  render: ->
    <div className="single-food">
      { if (@state.food) then <FoodCard model={@state.food} /> }
    </div>
