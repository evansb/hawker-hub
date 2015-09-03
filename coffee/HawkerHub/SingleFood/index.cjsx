_       = require 'lodash'
React   = require 'react'
FoodCardList = require '../Food/FoodCardList'
{ FilterAction } = require '../../Entity/Filter'

module.exports = React.createClass
  componentDidMount: ->
    FilterAction.change { name: 'single', arg: @props.params.id }
  render: ->
    <FoodCardList />
