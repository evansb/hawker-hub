_       = require 'lodash'
React   = require 'react'
FoodCard = require '../Food/FoodCard'
{ SingleFoodStore, SingleFoodAction } = require '../../Entity/SingleFood'

module.exports = React.createClass
  getInitialState: -> { food: null }
  componentWillMount: ->
    id = @props.params.id
    SingleFoodStore.listen (food) => @setState { food }
    SingleFoodAction.fetch id
  render: ->
    <div className="container single-food">
      { if (@state.food) then <FoodCard model={@state.food} /> }
    </div>
