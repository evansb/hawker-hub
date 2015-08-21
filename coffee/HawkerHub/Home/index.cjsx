_       = require 'lodash'
React   = require 'react'
UI      = require 'material-ui'
Colors  = require 'material-ui/lib/styles/colors'
UITheme = require '../Common/UITheme'
FoodCardList = require './FoodCardList'

friendTab =
  label: "Friends"
  filter: -> true

nearYouTab =
  label: "Near You"
  filter: -> true

activities =
  label: "Activities"
  filter: -> true

tabs = _.map [friendTab, nearYouTab, activities], (value, index) ->
  value.key = index
  value

items = [
  { name: "Durian", location: "Your Mum's Home"}
  { name: "Apple", location: "Wait what"}
  { name: "Durian", location: "Your Mum's Home"}
  { name: "Apple", location: "Wait what"}
  { name: "Apple", location: "Wait what"}
  { name: "Durian", location: "Your Mum's Home"}
  { name: "Apple", location: "Wait what"}
]

module.exports = React.createClass
  mixins: [UITheme]
  tabStyle:
    "color": Colors.red500
  render: ->
    <UI.Tabs>
      { _.map tabs, (value) =>
        <UI.Tab key={value.key} label={value.label} style={@tabStyle} >
          <FoodCardList items={items} />
        </UI.Tab>
      }
    </UI.Tabs>
